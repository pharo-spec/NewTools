"
Description
--------------------

I represent a flag location. The location is the method in which it was defined. 

I am used by FBFlag.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	classLocation:		<aClass>			Class of the compiled method containing the flag.
	flag:					<aFlag>			Flag which is present at this location.
	interval:				<anInterval>		Interval in the code where the flag is.
	selector:				<aSelector>		Selector of the compiled method containing the flag.

"
Class {
	#name : #FBLocation,
	#superclass : #Object,
	#instVars : [
		'classLocation',
		'selector',
		'interval',
		'flag'
	],
	#category : #'FlagBrowser-Model'
}

{ #category : #'instance creation' }
FBLocation class >> class: aClass selector: aMethodSelector interval: anInterval [
	^ self new
		classLocation: aClass;
		selector: aMethodSelector;
		interval: anInterval;
		yourself
]

{ #category : #comparing }
FBLocation >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ selector = anObject selector and: [ classLocation = anObject classLocation and: [ interval = anObject interval ] ]
]

{ #category : #accessing }
FBLocation >> classLocation [
	^ classLocation
]

{ #category : #accessing }
FBLocation >> classLocation: anObject [
	classLocation := anObject
]

{ #category : #accessing }
FBLocation >> compiledMethod [
	^ self classLocation >> self selector
]

{ #category : #accessing }
FBLocation >> flag [
	^ flag
]

{ #category : #accessing }
FBLocation >> flag: aFlag [
	flag := aFlag
]

{ #category : #comparing }
FBLocation >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ selector hash bitXor: (classLocation hash bitXor: interval hash)
]

{ #category : #accessing }
FBLocation >> interval [
	^ interval
]

{ #category : #accessing }
FBLocation >> interval: anObject [
	interval := anObject
]

{ #category : #accessing }
FBLocation >> package [
	^ self classLocation package
]

{ #category : #accessing }
FBLocation >> selector [
	^ selector
]

{ #category : #accessing }
FBLocation >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
FBLocation >> sourceCode [
	^ self compiledMethod sourceCode
]
