"
I am a model of a scope, which can be composed of several kinds of RBBrowserEnvironment (for example: RBClassHierarchyEnvironment, RBPackageEnvironment, RBClassEnvironment)
"
Class {
	#name : 'ScopeModel',
	#superclass : 'Object',
	#instVars : [
		'environment',
		'packages'
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
ScopeModel >> environment [
	^ environment
]

{ #category : 'accessing' }
ScopeModel >> environment: aSmalltalkImage [ 
	environment := aSmalltalkImage
]

{ #category : 'accessing' }
ScopeModel >> packages [
	^ packages ifNil: [packages := self environment packages collect: [ :p | ScopePackageModel on: p ] ]
]

{ #category : 'as yet unclassified' }
ScopeModel >> updateWithNodes: aSetOfScopeNodes [

	| packages packageEnvironment |
	"I select all packages that have all their classes selected"
	packages := aSetOfScopeNodes select: [ :each |
		            each containsPackage and: [
			self halt.
			            each subelements allSatisfy: [ :class |
				            aSetOfScopeNodes asOrderedCollection includes: class ] ] ].
	packages ifNotEmpty: [
		packageEnvironment := RBPackageEnvironment packages:
			                      (packages collect: [ :p | p node ]) ].
	self halt.
]
