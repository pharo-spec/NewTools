"
I am a model of a scope, which can be composed of several kinds of RBBrowserEnvironment (for example: RBClassHierarchyEnvironment, RBPackageEnvironment, RBClassEnvironment)
"
Class {
	#name : 'ScopeModel',
	#superclass : 'Object',
	#instVars : [
		'environment',
		'allPackages'
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
ScopeModel >> environment [
	^ environment
]

{ #category : 'accessing' }
ScopeModel >> environment: aSmalltalkImage [ 
	environment := aSmalltalkImage
]

{ #category : 'as yet unclassified' }
ScopeModel >> updateWithNodes: aSetOfScopeNodes [

	| packageEnvironment packages |
	"Select all packages that have all their classes selected"
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
