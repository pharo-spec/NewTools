"
I am wrapper for classes, packages and class hierarchies to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeNode',
	#superclass : 'Object',
	#instVars : [
		'value',
		'packages'
	],
	#category : 'NewTools-Scopes-Browser-Nodes',
	#package : 'NewTools-Scopes-Browser',
	#tag : 'Nodes'
}

{ #category : 'instance creation' }
ScopeNode class >> on: aPackageOrClass [

	self class == ScopeNode ifTrue: [
		self error: 'I am ab abstract class' ].
	
	^ self new
		  value: aPackageOrClass;
		  yourself
]

{ #category : 'accessing' }
ScopeNode >> <= aNode [
	^ self label <= aNode label
]

{ #category : 'accessing' }
ScopeNode >> = anotherNode [

	^ (self class = anotherNode class)
		and: [ self label = anotherNode label ]
]

{ #category : 'accessing' }
ScopeNode >> basicEqualsTo: aNode [

	^ self value = aNode value
]

{ #category : 'accessing' }
ScopeNode >> children [
	self subclassResponsibility 
]

{ #category : 'accessing' }
ScopeNode >> definedClasses [
	^#()
]

{ #category : 'testing' }
ScopeNode >> isClassOrTraitNode [
	^ false
]

{ #category : 'testing' }
ScopeNode >> isPackageNode [
	^ false
]

{ #category : 'accessing' }
ScopeNode >> label [
	^ self value name
]

{ #category : 'accessing' }
ScopeNode >> name [
	^ value name
]

{ #category : 'accessing' }
ScopeNode >> package [
	^ value package
]

{ #category : 'accessing' }
ScopeNode >> printOn: aStream [

	aStream
		nextPutAll: self class name , '(' , self label;
		nextPutAll: ')'
]

{ #category : 'accessing' }
ScopeNode >> scopesIconName [
	self subclassResponsibility
]

{ #category : 'accessing' }
ScopeNode >> value [
	^ value
]

{ #category : 'accessing' }
ScopeNode >> value: aPackageOrClass [
	value := aPackageOrClass
]
