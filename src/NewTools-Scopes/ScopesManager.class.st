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
		'ActiveScope',
		'SingleInstance'
	],
	#category : 'NewTools-Scopes-Core',
	#package : 'NewTools-Scopes',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScopesManager class >> activeScope [
	^ ActiveScope
]

{ #category : 'accessing' }
ScopesManager class >> activeScope: aScope [

	ActiveScope := (self availableScopes includes: aScope)
		               ifTrue: [ aScope ]
		               ifFalse: [ nil ]
]

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

	| auxScope fullPackagesInCollection orphanClassesInCollection |

	aScope removeAll.
	auxScope := self newScopeFrom: aCollection.
	fullPackagesInCollection := auxScope fullPackages.
	orphanClassesInCollection := auxScope orphanClasses.
	
	fullPackagesInCollection do: [ :aPackage | aScope addPackage: aPackage ].
	orphanClassesInCollection do: [ :aClass | aScope addClass: aClass ].
	
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

	| aSet packageScope classScope classes packages classesInPackages label newScope |

	aSet := aCollection asSet.
	packages := aSet select: [ :each | each isKindOf: Package ].
	classesInPackages := packages flatCollect: [ :each | each definedClasses ].
	
	classes := ((aSet select: [ :each | each isClassOrTrait ]) reject: [
		           :each | each isMeta or: [classesInPackages includes: each]]).
	
	classScope := RBClassEnvironment classes: classes.
	packageScope := RBPackageEnvironment packages: packages.
	newScope := classScope | packageScope.
	
	label := self defaultNameForScope: newScope.
	^ newScope label: label; yourself
]

{ #category : 'accessing' }
ScopesManager class >> removeScope: aScope [
	self singleInstance removeScope: aScope
]

{ #category : 'class initialization' }
ScopesManager class >> reset [
	<script>
	SingleInstance ifNotNil: [ SingleInstance reset ].
	SingleInstance := nil
]

{ #category : 'accessing' }
ScopesManager class >> scopes [
	^ self singleInstance scopes asArray
]

{ #category : 'accessing' }
ScopesManager class >> singleInstance [

	^ SingleInstance ifNil: [
		  SingleInstance := self basicNew
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
		  defaultScope := self scopeClass new label:
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
	^ RBBrowserEnvironment 
]

{ #category : 'accessing' }
ScopesManager >> scopes [

	^ scopes
]
