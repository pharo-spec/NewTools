"
I store and manage user created scopes
"
Class {
	#name : 'ScopesManager',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'environment',
		'announcer'
	],
	#classVars : [
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
ScopesManager class >> invalidNames [
	^ self scopes collect: [ :e | e label ]
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

	^ environment current packages select: [ :package | package definedClasses isNotEmpty ]
]

{ #category : 'accessing' }
ScopesManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'api' }
ScopesManager >> defaultScope [

	^ (self scopeClass packages: self allPackagesInEnvironment) label:
		  self defaultScopeLabel
]

{ #category : 'accessing' }
ScopesManager >> defaultScopeLabel [

	^ 'Full environment'
]

{ #category : 'api' }
ScopesManager >> environment [

	^ environment
]

{ #category : 'api' }
ScopesManager >> environment: aSmalltalkImage [

	environment := aSmalltalkImage
]

{ #category : 'initialization' }
ScopesManager >> initialize [

	environment ifNil: [ environment := SmalltalkImage ].
	scopes := Set new
]

{ #category : 'private' }
ScopesManager >> newScopeFrom: aSet [

	| packageScope classScope classes packages orphanClasses fullPackages compositeScope |
	
	classes := aSet select: [ :each | each isClassOrTrait ].
	packages := aSet select: [ :each | each isKindOf: RPackage ].

	"classes whose package hasn't all of its classes selected"
	orphanClasses := classes select: [ :class |
		                 | siblings |
		                 siblings := class package definedClasses.
		                 siblings anySatisfy: [ :sibling |
			                 classes noneSatisfy: [ :selectedClass |
				                 selectedClass = sibling ] ] ].
	
	"packages whose classes were all selected"
	fullPackages := packages select: [ :each |
		                each definedClasses noneSatisfy: [ :class |
			                orphanClasses anySatisfy: [ :orphan |
				                orphan = class ] ] ].
	
	classScope := RBClassEnvironment classes: orphanClasses.
	packageScope := RBPackageEnvironment packages: fullPackages.
	
	self flag: 'hacer recursiva la construccion del composite scope'.
	(classScope isNotEmpty and: [ packageScope isNotEmpty ]) ifTrue: [ 
		compositeScope := packageScope | classScope ].

	compositeScope ifNotNil: [ ^ compositeScope ].
	packageScope isEmpty ifFalse: [ ^ packageScope ].
	classScope isEmpty ifFalse: [ ^ classScope ].
	self error: 'Impossible to create scope from nodes'.
	

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
