Class {
	#name : 'ScopesManager',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'announcer',
		'environment',
		'newScope'
	],
	#classVars : [
		'singleInstance'
	],
	#category : 'NewTools-Scopes-Core',
	#package : 'NewTools-Scopes',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScopesManager class >> reset [
	singleInstance ifNotNil: [ singleInstance reset ].
	singleInstance := nil
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
	scopes add: aScope
]

{ #category : 'accessing' }
ScopesManager >> allPackagesInEnvironment [

	^ environment current packages
]

{ #category : 'accessing' }
ScopesManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'api' }
ScopesManager >> environment: aSmalltalkImage [

	environment := aSmalltalkImage
]

{ #category : 'initialization' }
ScopesManager >> initialize [
	environment := SmalltalkImage
]

{ #category : 'accessing' }
ScopesManager >> newScope [
	^ newScope
]

{ #category : 'accessing' }
ScopesManager >> newScope: anObject [

	newScope := anObject
]

{ #category : 'private' }
ScopesManager >> newScopeFrom: aSetOfNodes [

	| packageScope classScope classes packages orphanClasses fullPackages compositeScope |
	
	packages := aSetOfNodes select: [ :node | node isPackageNode ] thenCollect: [:node | node value].
	classes := aSetOfNodes select: [ :node | node isClassOrTraitNode ] thenCollect: [:node | node value].

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
	scopes := nil.
	self announcer subscriptions reset.
	self resetNewScope
]

{ #category : 'accessing' }
ScopesManager >> resetNewScope [

	newScope := nil
]

{ #category : 'accessing' }
ScopesManager >> scopes [

	^ scopes ifNil: [ scopes := Set new ]
]
