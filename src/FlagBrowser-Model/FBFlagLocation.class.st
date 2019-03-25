Class {
	#name : #FBFlagLocation,
	#superclass : #Object,
	#instVars : [
		'classLocation',
		'selector'
	],
	#category : #'FlagBrowser-Model'
}

{ #category : #'instance creation' }
FBFlagLocation class >> class: aClass selector: aMethodSelector [
	^ self new
		classLocation: aClass;
		selector: aMethodSelector;
		yourself
]

{ #category : #comparing }
FBFlagLocation >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ selector = anObject selector and: [ classLocation = anObject classLocation ]
]

{ #category : #accessing }
FBFlagLocation >> classLocation [
	^ classLocation
]

{ #category : #accessing }
FBFlagLocation >> classLocation: anObject [
	classLocation := anObject
]

{ #category : #accessing }
FBFlagLocation >> compiledMethod [
	^ self classLocation >> self selector
]

{ #category : #comparing }
FBFlagLocation >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ selector hash bitXor: classLocation hash
]

{ #category : #accessing }
FBFlagLocation >> selector [
	^ selector
]

{ #category : #accessing }
FBFlagLocation >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
FBFlagLocation >> sourceCode [
	^ self compiledMethod sourceCode
]
