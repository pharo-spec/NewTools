"
I am a model of a scope, which can be composed of several kinds of RBBrowserEnvironment (for example: RBClassHierarchyEnvironment, RBPackageEnvironment, RBClassEnvironment)
"
Class {
	#name : 'ScopeModel',
	#superclass : 'Object',
	#instVars : [
		'environment',
		'allPackages',
		'announcer'
	],
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeModel class >> default [
	^ self new
		environment: Smalltalk;
		yourself
]

{ #category : 'accessing' }
ScopeModel >> allPackages [

	^ allPackages ifNil: [
		  allPackages := (self environment packages collect: [ :p |
			                 ScopePackageModel on: p ]) sorted ]
]

{ #category : 'announcements' }
ScopeModel >> announcer: anAnnouncer [
	announcer := anAnnouncer
]

{ #category : 'accessing' }
ScopeModel >> environment [
	^ environment
]

{ #category : 'accessing' }
ScopeModel >> environment: aSmalltalkImage [ 
	environment := aSmalltalkImage
]

{ #category : 'private' }
ScopeModel >> newScopeFrom: aSetOfNodes [

	| packageScope classScope packages classes packageNodes classNodes orphanClasses fullPackages compositeScope |
	
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
	
	(classScope isEmpty not and: [ packageScope isEmpty not ]) ifTrue: [ 
		compositeScope := RBCompositeEnvironment onEnvironment: classScope and: packageScope ].
	
	compositeScope ifNotNil: [ ^ compositeScope ].
	packageScope isEmpty ifFalse: [ ^ packageScope ].
	classScope isEmpty ifFalse: [ ^ classScope ].
	self error: 'Impossible to create scope from nodes'.
	

]
