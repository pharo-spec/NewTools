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
ScopeNodeModel >> <= aNode [
	^ self name <= aNode name
]

{ #category : 'accessing' }
ScopeNodeModel >> = anotherNode [

	^ (self basicEqualsTo: anotherNode)
		and: [ self subelements asSet = anotherNode subelements asSet ]
]

{ #category : 'accessing' }
ScopeNodeModel >> basicEqualsTo: aNode [

	^ self node = aNode node
]

{ #category : 'accessing' }
ScopeNodeModel >> containsPackage [
	^ false
]

{ #category : 'accessing' }
ScopeNodeModel >> definedClasses [
	^#()
]

{ #category : 'accessing' }
ScopeNodeModel >> name [
	^ node name
]

{ #category : 'accessing' }
ScopeNodeModel >> node [
	^ node
]

{ #category : 'accessing' }
ScopeNodeModel >> node: aNode [
	node := aNode
]

{ #category : 'accessing' }
ScopeNodeModel >> package [
	^ node package
]

{ #category : 'accessing' }
ScopeNodeModel >> scopesIconName [
	self subclassResponsibility
]

{ #category : 'accessing' }
ScopeNodeModel >> subelements [
	self subclassResponsibility 
]
