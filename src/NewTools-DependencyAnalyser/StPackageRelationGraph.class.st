"
I'm a package dependency graph. 
To compute dependencies of a set of packages you are interested in, you can use:
```language=Pharo
DADependencyChecker new buildPackageRelationGraphFor: 'Tool-Diff'.
```

"
Class {
	#name : 'StPackageRelationGraph',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'classMapping',
		'shouldComputeMessageSendDependencies'
	],
	#category : 'NewTools-DependencyAnalyser-Core',
	#package : 'NewTools-DependencyAnalyser',
	#tag : 'Core'
}

{ #category : 'instance creation' }
StPackageRelationGraph class >> new [
	^ self onPackages: OrderedCollection new
]

{ #category : 'instance creation' }
StPackageRelationGraph class >> onPackages: aListOfDAPackages [
	^ self basicNew
		initializeWithPackages: aListOfDAPackages;
		yourself
]

{ #category : 'instance creation' }
StPackageRelationGraph class >> onPackagesNamed: packageNames [

	^ self onPackages: (packageNames collect: [ :each | StPackage onPackageNamed: each ])
]

{ #category : 'adding' }
StPackageRelationGraph >> addExtensionDependencies: aDAPackage [

	aDAPackage systemPackage ifNotNil: [ :package |
		package extensionMethods do: [ :method |
			| packageOfExtendedClass |
			packageOfExtendedClass := self packageForBehavior: method methodClass.
			self addPackage: packageOfExtendedClass.
			aDAPackage add: ((StExtensionDependency from: aDAPackage to: packageOfExtendedClass)
					 theClass: method methodClass;
					 selector: method selector asSymbol;
					 method: method) ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addInheritanceDependencies: aPackage [
	| package |
	self package: aPackage
		classesDo: [ :class |
			class superclass ifNotNil: [
					package := self packageForBehavior: class superclass.
					aPackage
						add:
							((StInheritanceDependency from: aPackage to: package)
								theClass: class;
								superclass: class superclass).
					self addPackage: package ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addMessageSendDependencies: aPackage [
	| analyser |
	analyser := (StMessageSendAnalyzer basicNew
		initializeWith: aPackage;
		yourself).

	analyser manuallyResolvedDependencies do:
		[ :packageName |
		(analyser missingMethodsImplementedIn: packageName)
			ifEmpty: [ StPotentialOutDatedDependencyWarning signalDependency: packageName on: aPackage packageName ]
			ifNotEmpty: 	[ :implementedMethods |
				aPackage add: ((StMessageSendDependency from: aPackage to: (self daPackageWith: packageName))
					implementedMethods: implementedMethods;
					yourself) ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addPackage: aPDPackage [
	aPDPackage beIncluded.
	packages
		at: aPDPackage packageName
		put: aPDPackage
]

{ #category : 'adding' }
StPackageRelationGraph >> addPackages: aListOfDAPackages [

	aListOfDAPackages
		do: [ :package | self addPackage: package ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addPoolDictionaryDependencies: aPackage [
	"Iterate all classes in the package.
	Add a pool dictionary dependency for each pool dictionary used in the package."

	self package: aPackage
		classesDo: [ :class |
			class sharedPoolsDo: [ :each | | targetPackage |
				targetPackage := self packageForBehavior: each.
				aPackage
					add: ((StPoolDictionaryDependency from: aPackage to: targetPackage)
						theClass: class;
						poolDictionary: each).
				self addPackage: targetPackage ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addReferenceDependencies: aPackage [
	(self methodsFor: aPackage)
		do: [ :method | self findReferencesIn: method for: aPackage ]
]

{ #category : 'adding' }
StPackageRelationGraph >> addTraitDependencies: aPackage [
	| package |
	self package: aPackage
		classesDo: [ :class |
			class traits
				do: [ :trait |
					package := self packageForBehavior: trait.
					aPackage
						add:
							((StTraitDependency from: aPackage to: package)
								theClass: class;
								trait: trait).
					self addPackage: package ] ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> allDependentPackagesFromSeenPackages [
	| aSet |
	aSet := Set new.
	self seenPackages do: [ :seenPackage |
		aSet addAll: (seenPackage dependentPackages) ].

	^ aSet
]

{ #category : 'computing' }
StPackageRelationGraph >> allExtensionDependencies [
	| aCollectionOfExtensionDependency |
	aCollectionOfExtensionDependency := OrderedCollection new.

	self seenPackages do: [ :each |
		each dependencies do: [ :dependency |
			aCollectionOfExtensionDependency addAll: dependency extensionDependencies.
			 ]
		 ].
	^ aCollectionOfExtensionDependency
]

{ #category : 'computing' }
StPackageRelationGraph >> allReferenceDependencies [
	| aCollectionOfReferenceDependency |
	aCollectionOfReferenceDependency := OrderedCollection new.

	self seenPackages do: [ :each |
		each dependencies do: [ :dependency |
			aCollectionOfReferenceDependency addAll: dependency referenceDependencies.
			 ]
		 ].
	^ aCollectionOfReferenceDependency
]

{ #category : 'testing' }
StPackageRelationGraph >> allSeen [

	^ self packages allSatisfy: [ :each | each isSeen ]
]

{ #category : 'building' }
StPackageRelationGraph >> build [
	"build the dependency graph"
	self
		computeStaticDependencies;
		removeInternalDependencies;
		combineDependencies
]

{ #category : 'actions' }
StPackageRelationGraph >> clearAllDependencies [
	packages do: [ :package | package clearDependencies ]
]

{ #category : 'updating' }
StPackageRelationGraph >> clearPackages [
	packages := Dictionary new
]

{ #category : 'actions' }
StPackageRelationGraph >> combineDependencies [
	"Combine all dependencies with the same source and target into one composite dependency."
	self packages do: [ :each | self combineDependencies: each ]
]

{ #category : 'private' }
StPackageRelationGraph >> combineDependencies: aPackage [
	| grouped composite |
	grouped := aPackage dependencies
		groupedBy: [ :each | each target ]
		having: [ :each | true ].

	aPackage clearDependencies.

	grouped keysAndValuesDo: [ :target :dependencies |
		composite := StCompositeDependency from: aPackage to: target.
		dependencies do: [ :each | composite add: each ].
		aPackage add: composite ]
]

{ #category : 'adding' }
StPackageRelationGraph >> computeStaticDependencies [
	self packages
		do: [ :each |
			each isSeen
				ifFalse: [
					self computeStaticDependencies: each.
					each beSeen ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> computeStaticDependencies: aPackage [

	self addInheritanceDependencies: aPackage.
	self addExtensionDependencies: aPackage.
	self addReferenceDependencies: aPackage.
	self addPoolDictionaryDependencies: aPackage.
	self addTraitDependencies: aPackage.
	self shouldComputeMessageSendDependencies 
		ifTrue: [ self addMessageSendDependencies: aPackage ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> daPackageWith: packageName [

	^ StPackage onPackageNamed: packageName
]

{ #category : 'accessing' }
StPackageRelationGraph >> dependenciesFrom: aPackage [
	"Answer all seen packages."

	^ (packages at: aPackage) dependencies
]

{ #category : 'adding' }
StPackageRelationGraph >> findReferencesIn: aMethod for: aPackage [
	| package compiledMethod allCompiledCode |

	compiledMethod := aMethod compiledMethod.
	compiledMethod ifNil: [ ^ self ].

	allCompiledCode := compiledMethod withAllBlocks.

	allCompiledCode do: [ :aCompiledCode |
			aCompiledCode literals do: [ :literal |
					(self isReference: literal)
						ifTrue: [
							package := self packageForBehavior: literal value.
							self addPackage: package.
							aPackage
								add:
									((StReferenceDependency from: aPackage to: package)
										theClass: aMethod methodClass;
										selector: aMethod method selector asSymbol;
										reference: literal value;
										method: aMethod;
										yourself) ] ] ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> includedPackages [
	"Answer the currently analyzed set of packages."

	^ self packages select: [ :each | each isIncluded ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> includesSeenPackage: aPackage [
	^ self seenPackages includes: aPackage
]

{ #category : 'initialization' }
StPackageRelationGraph >> initializeWithPackages: aListOfDAPackages [
	self initialize.
	packages := Dictionary new.
	aListOfDAPackages do: [ :each | self addPackage: each ].
	classMapping := IdentityDictionary new
]

{ #category : 'testing' }
StPackageRelationGraph >> isReference: aLiteral [
	^ aLiteral isVariableBinding and: [ aLiteral value isBehavior and: [ aLiteral key = aLiteral value name ] ]
]

{ #category : 'adding' }
StPackageRelationGraph >> methodsFor: aPackage [

	^ aPackage systemPackage
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :package | package methods ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> outgoing [
	"Answer a collection of all dependencies that point out of the current package set."

	^ self includedPackages
		inject: Bag new
		into: [ :outgoing :package |
			package dependencies do: [ :each |
				(each isInternal or: [ each target isIncluded ])
					ifFalse: [ outgoing add: each ] ].
			outgoing ]
]

{ #category : 'enumerating' }
StPackageRelationGraph >> package: aPackage classesDo: aBlock [
	"Evaluate aBlock with each class aPackage defines. Not the classes it only extends: their superclass, traits and pools are dependencies of the package defining them"

	aPackage systemPackage ifNotNil: [ :package | package definedClasses do: aBlock ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> packageAt: aPackageName [
	"answer a DAPackage"

	^ (packages keys includes: aPackageName)
		ifTrue: [ packages at: aPackageName ]
		ifFalse: [ nil ]
]

{ #category : 'queries' }
StPackageRelationGraph >> packageForBehavior: aClass [
	"return a PDPackage and put in classToPackage"

	^ classMapping at: aClass ifAbsentPut: [
		  self packages
			  detect: [ :each |
				  each systemPackage
					  ifNil: [ false ]
					  ifNotNil: [ :package | package includesClass: aClass ] ]
			  ifNone: [ self systemPackageContaining: aClass ] ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> packageForClass: aClass [

	^ packages detect: [ :package | package systemPackage includesClass: aClass ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> packageNamed: aString ifAbsent: aBlock [
	^ packages at: aString ifAbsent: aBlock
]

{ #category : 'accessing' }
StPackageRelationGraph >> packages [

	^ packages values
]

{ #category : 'accessing' }
StPackageRelationGraph >> packagesName [

	^ packages keys
]

{ #category : 'accessing' }
StPackageRelationGraph >> predecessors: aPackage [
	"returns a Collection with the predecessors of the package"

	| aCollection |
	aCollection := OrderedCollection new.
	self packages
		do: [ :package |
			package dependencies
				do: [ :dependency |
					dependency target = aPackage
						ifTrue: [ aCollection add: package ] ] ].
	^ aCollection
]

{ #category : 'updating' }
StPackageRelationGraph >> refreshGraph [
	| packageNames |

	packageNames := self seenPackagesName.
	self initializeWithPackages: (packageNames collect: [ :packageName | self daPackageWith: packageName]).
	self build
]

{ #category : 'updating' }
StPackageRelationGraph >> refreshPackageDependencies: aPackage [
	aPackage clearDependencies.
	self computeStaticDependencies: aPackage.
	self combineDependencies: aPackage.
	aPackage removeAllInternal.
	aPackage beSeen
]

{ #category : 'actions' }
StPackageRelationGraph >> removeInternalDependencies [
	"Remove all dependencies from a package to itself"
	self includedPackages do: [ :each | each removeAllInternal ]
]

{ #category : 'actions' }
StPackageRelationGraph >> removeOutgoingDependencies [
	"Remove all dependencies to packages not included in this relation"

	self includedPackages
		do: [ :each | self removeOutgoingDependencies: each ]
		displayingProgress: 'Removing outgoing Dependencies'
]

{ #category : 'private' }
StPackageRelationGraph >> removeOutgoingDependencies: aPackage [
	| removals |
	removals := aPackage dependencies reject: [ :each | each target isIncluded ].
	removals do: [ :each | aPackage remove: each ]
]

{ #category : 'removing' }
StPackageRelationGraph >> removePackage: packageName [
	^ packages removeKey: packageName
]

{ #category : 'actions' }
StPackageRelationGraph >> seenPackages [
	^ self packages
		select: [ :each | each isSeen ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> seenPackagesName [
	"Answer all seen packages name."

	^ self seenPackages collect: [ :package | package packageName ]
]

{ #category : 'actions' }
StPackageRelationGraph >> seenPackagesWithFilter: aFilter [
	^ self packages
		select: [ :each | each isSeen and: [ aFilter match: each packageName ] ]
]

{ #category : 'actions' }
StPackageRelationGraph >> seenPackagesWithoutExtension [
	^ self packages select: [ :each | each isSeen ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> shouldComputeMessageSendDependencies [

	^ shouldComputeMessageSendDependencies ifNil: [ true ]
]

{ #category : 'accessing' }
StPackageRelationGraph >> shouldComputeMessageSendDependencies: aBoolean [

	shouldComputeMessageSendDependencies := aBoolean
]

{ #category : 'accessing' }
StPackageRelationGraph >> successors: aPackage [
	"answer a collection with the successors of aPackage in the graph"

	| aCollection |
	aCollection := OrderedCollection new.
	(packages at: aPackage packageName) dependencies
		do: [ :dependency |
			(self packagesName includes: dependency target packageName)
				ifTrue: [ aCollection add: dependency target ] ].
	^ aCollection
]

{ #category : 'queries' }
StPackageRelationGraph >> systemPackageContaining: aClass [

	^ aClass package name
		  ifNil: [ self error: 'Package for ' , aClass name , ' not found.' ]
		  ifNotNil: [ :packageName | StPackage onPackageNamed: packageName asString ]
]

{ #category : 'computing' }
StPackageRelationGraph >> usersOf: aPackage [
	| users |
	users := OrderedCollection new.
	self seenPackages
		do: [ :package |
			(package dependentPackages includes: aPackage)
				ifTrue: [ users add: package ] ].
	^ users
]
