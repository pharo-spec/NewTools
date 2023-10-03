"
I am a model of a scope, which can be composed of several kinds of RBBrowserEnvironment (for example: RBClassHierarchyEnvironment, RBPackageEnvironment, RBClassEnvironment)
"
Class {
	#name : 'ScopeModel',
	#superclass : 'Object',
	#instVars : [
		'environment',
		'scopes',
		'announcer',
		'packages'
	],
	#classVars : [
		'singleInstance'
	],
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeModel class >> singleInstance [

	^ singleInstance ifNil: [
		  singleInstance := self basicNew
			                    environment: Smalltalk;
			                    initialize;
			                    yourself ]
]

{ #category : 'accessing' }
ScopeModel >> addScope: aRBEnvironment [

	self scopes add: (ScopeScopeModel on: aRBEnvironment) 
]

{ #category : 'accessing' }
ScopeModel >> announcer [
	^ announcer
]

{ #category : 'accessing' }
ScopeModel >> environment [
	^ environment
]

{ #category : 'accessing' }
ScopeModel >> environment: aSmalltalkImage [ 
	environment := aSmalltalkImage
]

{ #category : 'initialization' }
ScopeModel >> initialize [
	super initialize.
	announcer := Announcer new
]

{ #category : 'private' }
ScopeModel >> newScopeFrom: aSetOfNodes [

	| packageScope classScope packages classes orphanClasses fullPackages compositeScope |
	
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

{ #category : 'accessing' }
ScopeModel >> packages [

	^ packages ifNil: [
		  packages := (self environment packages collect: [ :p |
			                 ScopePackageModel on: p ]) sorted ]
]

{ #category : 'initialization' }
ScopeModel >> reset [
	scopes := nil
]

{ #category : 'initialization' }
ScopeModel >> scopes [
	^ scopes ifNil: [ scopes := Set new ]
]
