"
I am wrapper for classes, packages and class hierarchies to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeNodeModel',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'instance creation' }
ScopeNodeModel class >> on: aPackageOrClass [
	^ self new
		value: aPackageOrClass;
		yourself
]

{ #category : 'accessing' }
ScopeNodeModel >> <= aNode [
	^ self name <= aNode name
]

{ #category : 'accessing' }
ScopeNodeModel >> = anotherNode [

	^ (self class = anotherNode class)
		and: [ self name = anotherNode name ]
]

{ #category : 'accessing' }
ScopeNodeModel >> basicEqualsTo: aNode [

	^ self value = aNode value
]

{ #category : 'accessing' }
ScopeNodeModel >> children [
	self subclassResponsibility 
]

{ #category : 'accessing' }
ScopeNodeModel >> definedClasses [
	^#()
]

{ #category : 'testing' }
ScopeNodeModel >> isClassOrTraitNode [
	^ false
]

{ #category : 'testing' }
ScopeNodeModel >> isPackageNode [
	^ false
]

{ #category : 'accessing' }
ScopeNodeModel >> name [
	^ value name
]

{ #category : 'accessing' }
ScopeNodeModel >> package [
	^ value package
]

{ #category : 'accessing' }
ScopeNodeModel >> printOn: aStream [
	aStream
		nextPutAll: self class name , '(', self value name ,')'
]

{ #category : 'accessing' }
ScopeNodeModel >> scopesIconName [
	self subclassResponsibility
]

{ #category : 'accessing' }
ScopeNodeModel >> value [
	^ value
]

{ #category : 'accessing' }
ScopeNodeModel >> value: aPackageOrClass [
	value := aPackageOrClass
]
