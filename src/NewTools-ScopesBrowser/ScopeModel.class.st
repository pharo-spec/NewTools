"
I am a model of a scope, which can be composed of several kinds of RBBrowserEnvironment (for example: RBClassHierarchyEnvironment, RBPackageEnvironment, RBClassEnvironment)
"
Class {
	#name : 'ScopeModel',
	#superclass : 'Object',
	#instVars : [
		'environment'
	],
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeModel class >> default [
	^ Smalltalk packages sorted collect: [ :package | ScopePackageModel on: package ]
]

{ #category : 'as yet unclassified' }
ScopeModel >> updateWithNodes: aSetOfScopeNodes [
	self halt.
]
