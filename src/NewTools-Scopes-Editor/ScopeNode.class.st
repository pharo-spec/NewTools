"
I am an abstract wrapper for classes, packages and traits to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeNode',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'NewTools-Scopes-Editor-Nodes',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'Nodes'
}

{ #category : 'instance creation' }
ScopeNode class >> on: aRBEnvironment [

	self class == ScopeNode ifTrue: [
		self error: 'I am an abstract class' ].
	
	^ self new
		  value: aRBEnvironment;
		  yourself
]

{ #category : 'operations' }
ScopeNode >> & anotherNode [

	^ ScopesManager newScopeFrom: self value and: anotherNode value
]

{ #category : 'comparing' }
ScopeNode >> <= aNode [
	^ self label <= aNode label
]

{ #category : 'comparing' }
ScopeNode >> = anotherNode [

	^ (self class = anotherNode class)
		and: [ self label = anotherNode label ]
]

{ #category : 'comparing' }
ScopeNode >> == anotherNode [

	^ self = anotherNode
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

{ #category : 'comparing' }
ScopeNode >> hash [
	^ value hash
]

{ #category : 'testing' }
ScopeNode >> isClassNode [
	^ false
]

{ #category : 'testing' }
ScopeNode >> isClassOrTraitNode [
	^ false
]

{ #category : 'testing' }
ScopeNode >> isPackageNode [
	^ false
]

{ #category : 'testing' }
ScopeNode >> isScopeNode [
	^ false
]

{ #category : 'accessing' }
ScopeNode >> label [

	^ self value name , ' [package: ' , self value package name , ']'
]

{ #category : 'accessing' }
ScopeNode >> name [
	^ value name
]

{ #category : 'operations' }
ScopeNode >> not [

	^ ScopesManager newScopeFromNot: self value
]

{ #category : 'accessing' }
ScopeNode >> package [
	^ value package
]

{ #category : 'accessing' }
ScopeNode >> packageNode [
	self subclassResponsibility 
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

{ #category : 'operations' }
ScopeNode >> | anotherNode [

	^ self value | anotherNode value
]
