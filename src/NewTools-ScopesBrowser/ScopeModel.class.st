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

{ #category : 'as yet unclassified' }
ScopeModel >> allPackages [
	^ allPackages ifNil: [ allPackages := self environment packages collect: [ :p | ScopePackageModel on: p ] ]
]

{ #category : 'accessing' }
ScopeModel >> announcer: anAnnouncer [
	announcer := anAnnouncer
]

{ #category : 'as yet unclassified' }
ScopeModel >> classEnvironmentFrom: aSetOfNodes [
	| classEnvironment compositeEnvironment classNodes selectedClassNodes |
	
	classEnvironment := RBClassEnvironment new.
	compositeEnvironment := RBCompositeEnvironment new.
	
	
	"include all classes belonging to a package whose classes weren't all selected"
	classNodes := aSetOfNodes select: [ :each | each isClassNode ].
	selectedClassNodes := classNodes copy.
	classNodes do: [ :classNode |
		#() do: [ :packageNode |
			(packageNode subelements includes: classNode) ifTrue: [
				selectedClassNodes remove: classNode ] ] ].
	classEnvironment classes:
		                    (selectedClassNodes collect: [ :c | c node ]).	
	^ classEnvironment
]

{ #category : 'accessing' }
ScopeModel >> environment [
	^ environment
]

{ #category : 'accessing' }
ScopeModel >> environment: aSmalltalkImage [ 
	environment := aSmalltalkImage
]

{ #category : 'as yet unclassified' }
ScopeModel >> packageEnvironmentFrom: nodes [
	| packageNodes selectedPackageNodes packageEnvironment |
	"Select all packages that have all their classes selected"
	packageEnvironment := RBPackageEnvironment new.
	"select packages whose classes were all selected"
	packageNodes := nodes select: [ :each | each isPackageNode ].
	selectedPackageNodes := packageNodes select: [ :each |
		                        each subelements allSatisfy: [ :classOrTrait |
			                        nodes includes: classOrTrait ] ].
	selectedPackageNodes ifNotEmpty: [
		packageEnvironment packages:
			                      (selectedPackageNodes collect: [ :p | p node ]) ].
	^ packageEnvironment 
]

{ #category : 'as yet unclassified' }
ScopeModel >> updateWithNodes: aSetOfNodes [

	| packageEnvironment  classEnvironment compositeEnvironment |
	
	packageEnvironment := self packageEnvironmentFrom: aSetOfNodes.
	classEnvironment := self classEnvironmentFrom: aSetOfNodes.
	announcer announce: (NewScopeAnnouncement on: classEnvironment )
	"(classEnvironment isEmpty or: [ packageEnvironment isEmpty ]) ifTrue: [ 
		 ]"
	
]
