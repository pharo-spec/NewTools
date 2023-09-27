"
I am wrapper for classes, packages and class hierarchies to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeNodeModel',
	#superclass : 'Object',
	#instVars : [
		'node'
	],
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'instance creation' }
ScopeNodeModel class >> on: aPackageOrClass [
	^ self new
		node: aPackageOrClass;
		yourself
]

{ #category : 'accessing' }
ScopeNodeModel >> name [
	^ node name
]

{ #category : 'accessing' }
ScopeNodeModel >> node: aNode [
	node := aNode
]

{ #category : 'accessing' }
ScopeNodeModel >> package [
	self subclassResponsibility 
]

{ #category : 'accessing' }
ScopeNodeModel >> scopesIconName [
	self subclassResponsibility
]

{ #category : 'accessing' }
ScopeNodeModel >> subelements [
	self subclassResponsibility 
]
