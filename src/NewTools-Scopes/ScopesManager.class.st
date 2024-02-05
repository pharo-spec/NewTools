"
I store and manage user created scopes
"
Class {
	#name : 'ScopesManager',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'environment',
		'announcer',
		'defaultScope',
		'currentQueryScope'
	],
	#classVars : [
		'ScopeRefactoring',
		'singleInstance'
	],
	#category : 'NewTools-Scopes-Core',
	#package : 'NewTools-Scopes',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScopesManager class >> addScope: aScope [
	self singleInstance addScope: aScope
]

{ #category : 'accessing' }
ScopesManager class >> availableScopes [

	^ self scopes
]

{ #category : 'accessing' }
ScopesManager class >> currentQueryScope [
	^ self singleInstance currentQueryScope
]

{ #category : 'accessing' }
ScopesManager class >> currentQueryScope: aScope [ 
	self singleInstance currentQueryScope: aScope
]

{ #category : 'operations' }
ScopesManager class >> defaultNameForScope: aScope [
	| packageScope classScope label |
	
	classScope := aScope environment.
	packageScope := aScope otherEnvironment.
	(packageScope isNotEmpty and: [ classScope isEmpty ]) 
		ifTrue: [ 
			label := 'Pck: ' , packageScope packages anyOne name ].
	(packageScope isEmpty and: [ classScope isNotEmpty ]) 
		ifTrue: [ 
			label := 'Cls: ' , classScope classes anyOne name ].
	(packageScope isNotEmpty and: [ classScope isNotEmpty ]) 
		ifTrue: [
			label := 'Pck,Cls: ' , packageScope packages anyOne name ].
	
	(classScope classes size + packageScope packages size) > 1 ifTrue: [ label := label , ', ...' ].
	
	^ self singleInstance nameWithIndex: label
	
]

{ #category : 'accessing' }
ScopesManager class >> defaultScope [

	^ self singleInstance defaultScope 
]

{ #category : 'accessing' }
ScopesManager class >> defaultScopeLabel [

	^ 'Full environment'
]

{ #category : 'operations' }
ScopesManager class >> editScope: aScope withNodes: aCollection [

	| classesInScope addedClasses removedClasses auxScope classesInCollection |
	
	classesInScope := aScope definedClasses.
	
	auxScope := self newScopeFrom: aCollection.
	classesInCollection := auxScope definedClasses.

	addedClasses := classesInCollection reject: [ :aClass |
		                classesInScope includes: aClass ].
	removedClasses := classesInScope reject: [ :aClass |
		                  classesInCollection includes: aClass ].

	addedClasses do: [ :aClass | aScope addClass: aClass ].
	removedClasses do: [ :aClass | aScope removeClass: aClass ].

	^ aScope
]

{ #category : 'private' }
ScopesManager class >> fullPackagesFrom: classes [
	"packages whose classes were all selected"

	| theClasses packagesCache packages classesCache |
	theClasses := classes reject: [ :each | each isMeta ].
	
	packages := theClasses collect:[:class | class package].
	packagesCache := Dictionary new.
	packages do: [ :package | packagesCache at: package put: package definedClasses  ].
	classesCache := Dictionary new.
	theClasses do: [ :class | classesCache at: class put: class package ].
	^ packages select: [ :package |
		  package definedClasses size
		  = (theClasses select: [ :class | (classesCache at: class) = package ]) size ]
]

{ #category : 'accessing' }
ScopesManager class >> invalidNames [

	^ { self defaultScopeLabel }
	  , (self scopes collect: [ :e | e label ])
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: aCollection [

	| aSet packageScope classScope classes packages orphanClasses fullPackages label newScope |
	aSet := aCollection asSet.
	classes := (aSet select: [ :each | each isClassOrTrait ]) reject: [
		           :each | each isMeta ].
	packages := aSet select: [ :each | each isKindOf: Package ].

	"packages whose classes were all selected"
	fullPackages := packages addAll: (self fullPackagesFrom: classes); yourself.
	"classes whose package hasn't all of its classes selected"
	orphanClasses := self
		                 orphanClassesIn: classes
		                 havingFullPackages: fullPackages.

	classScope := RBClassEnvironment classes: orphanClasses.
	packageScope := RBPackageEnvironment packages: fullPackages.
	newScope := classScope | packageScope.
	
	label := self defaultNameForScope: newScope.
	^ newScope label: label; yourself
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: scopeA and: scopeB [

	| classesA classesB classesInterAB packages fullPackages |
	
	classesA := scopeA classes asSet.
	classesB := scopeB classes.
	
	classesInterAB := (classesA, classesB) select: [ :each |
		                   (classesA includes: each) and: [
			                   classesB includes: each ] ].
	packages := classesInterAB collect: [ :each  | each package ].
	fullPackages := self fullPackagesFrom: classesInterAB.
	 
	^ self newScopeFrom: fullPackages , classesInterAB
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: classesAndPackages andHierarchies: hierarchies [

	| label newScope classesInHierarchies filteredClassesAndPackages otherEnvironment hierarchyEnvironment |
	"hierarchies contain classes defining hierarchy environments"
	classesInHierarchies := ((hierarchies flatCollect: [ :each |
			                          each allSuperclassesIncluding: Object ])
		                         addAll: hierarchies;
		                         yourself) asSet.

	filteredClassesAndPackages := classesAndPackages reject: [:each | each isClassOrTrait and: [ each isMeta or: [ classesInHierarchies includes: each ] ] ].

	otherEnvironment := self newScopeFrom: filteredClassesAndPackages.
	"The hierarchy environment is an OR environment containing all the class hierarchy environments"
	hierarchyEnvironment := RBOrEnvironment onEnvironments: (hierarchies collect: [:class | (RBClassHierarchyEnvironment class: class) label: 'Hier:',class name ; yourself  ]).
	
	newScope := otherEnvironment | hierarchyEnvironment.

	label := self defaultNameForScope: newScope.
	^ newScope
		  label: label;
		  yourself
]

{ #category : 'operations' }
ScopesManager class >> newScopeFromNot: scope [

	| classes rejectedFullPackages rejectedOrphanClasses rejectedClassesInFullPackages rejectedClasses acceptedPackages acceptedClasses |
	classes := scope classes.

	rejectedFullPackages := self fullPackagesFrom: classes.
	rejectedOrphanClasses := self
		                         orphanClassesIn: classes
		                         havingFullPackages: rejectedFullPackages.
	rejectedClassesInFullPackages := rejectedFullPackages collect: [
		                                 :each | each definedClasses ].
	rejectedClasses := rejectedOrphanClasses
	                   , rejectedClassesInFullPackages.

	acceptedPackages := self singleInstance allPackagesInEnvironment
		                    reject: [ :each |
		                    rejectedFullPackages includes: each name ].
	acceptedClasses := (self singleInstance allPackagesInEnvironment
		                    flatCollect: [ :each | each definedClasses ])
		                   reject: [ :each | rejectedClasses includes: each ].
	^ self newScopeFrom: acceptedPackages , acceptedClasses
]

{ #category : 'private' }
ScopesManager class >> orphanClassesIn: classes havingFullPackages: fullPackages [

	| theClasses packagesCache |
	theClasses := classes reject: [ :each | each isMeta ].
	packagesCache := Dictionary new.
	theClasses do: [ :each | packagesCache at: each put: each package ].
	^ theClasses reject: [ :class |
		  fullPackages includes: (packagesCache at: class) ]
]

{ #category : 'accessing' }
ScopesManager class >> removeScope: aScope [
	self singleInstance removeScope: aScope
]

{ #category : 'accessing' }
ScopesManager class >> reset [
	<script>
	singleInstance ifNotNil: [ singleInstance reset ].
	singleInstance := nil
]

{ #category : 'accessing' }
ScopesManager class >> scopes [
	^ self singleInstance scopes asArray
]

{ #category : 'accessing' }
ScopesManager class >> singleInstance [

	^ singleInstance ifNil: [
		  singleInstance := self basicNew
			                    environment: SmalltalkImage;
			                    initialize;
			                    yourself ]
]

{ #category : 'api' }
ScopesManager >> addScope: aScope [
	(scopes includes: aScope) ifTrue: [ ^ self ].
	scopes add: aScope
]

{ #category : 'accessing' }
ScopesManager >> allPackagesInEnvironment [

	^ (environment current packages select: [ :package |
		   package definedClasses isNotEmpty ]) sorted
]

{ #category : 'accessing' }
ScopesManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'accessing' }
ScopesManager >> currentQueryScope [
	^ currentQueryScope
]

{ #category : 'accessing' }
ScopesManager >> currentQueryScope: aScope [

	(scopes includes: aScope)
		ifTrue: [ currentQueryScope := aScope ]
		ifFalse: [ currentQueryScope := nil ]
]

{ #category : 'api' }
ScopesManager >> defaultScope [

	^ defaultScope ifNil: [
		  defaultScope := (self scopeClass packages:
			                   self allPackagesInEnvironment) label:
			                  self defaultScopeLabel ]
]

{ #category : 'accessing' }
ScopesManager >> defaultScopeLabel [

	^ self class defaultScopeLabel
]

{ #category : 'editing' }
ScopesManager >> editScope: aScope withNodes: aCollection [

	self class editScope: aScope withNodes: aCollection
]

{ #category : 'api' }
ScopesManager >> environment [

	^ environment
]

{ #category : 'api' }
ScopesManager >> environment: aSmalltalkImage [

	environment := aSmalltalkImage
]

{ #category : 'private' }
ScopesManager >> fullPackagesFrom: classes [ 
	^ self class fullPackagesFrom: classes
]

{ #category : 'initialization' }
ScopesManager >> initialize [

	environment ifNil: [ environment := SmalltalkImage ].
	scopes := Set new
]

{ #category : 'api' }
ScopesManager >> nameWithIndex: name [

	| existingNames hypen_index number indexes |
	existingNames := self class invalidNames select: [ :existing |
		                 existing includesSubstring: name ].
	existingNames isEmpty ifTrue: [ ^ name ].

	indexes := Set new.
	existingNames do: [ :existing |
		hypen_index := existing size - (existing reverse findString: '(').
		hypen_index = existing size
			ifTrue: [ indexes add: 0 ]
			ifFalse: [
				number := (existing copyFrom: hypen_index + 2 to: existing size)
					          asInteger.
				indexes add: number asInteger ] ].

	^ name , '(' , (indexes max + 1) asString, ')'
]

{ #category : 'private' }
ScopesManager >> newScopeFrom: aSetOfClassesAndPackages [

	^ self class newScopeFrom: aSetOfClassesAndPackages
]

{ #category : 'private' }
ScopesManager >> orphanClassesIn: classes havingFullPackages: fullPackages [

	^ self class
		  orphanClassesIn: classes
		  havingFullPackages: fullPackages
]

{ #category : 'removing' }
ScopesManager >> removeScope: aRBEnvironment [
	| removed |
	removed := scopes select: [ :scope | scope label = aRBEnvironment label ].
	removed do: [ :scope | scopes remove: scope ]
]

{ #category : 'initialization' }
ScopesManager >> reset [

	environment := nil.
	self announcer subscriptions reset.
	defaultScope := nil.
	scopes := #(  )
]

{ #category : 'running' }
ScopesManager >> scopeClass [
	^ RBPackageEnvironment 
]

{ #category : 'accessing' }
ScopesManager >> scopes [

	^ scopes
]
