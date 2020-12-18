"
I am a dumb object that accept visitors, to test Sindarin commands.
"
Class {
	#name : #SindarinTestObjectToVisit,
	#superclass : #Object,
	#category : #'NewTools-Sindarin-Commands-Tests'
}

{ #category : #visitors }
SindarinTestObjectToVisit >> acceptVisitor: aVisitor [

	aVisitor visitTestObject: self
]

{ #category : #visitors }
SindarinTestObjectToVisit >> doNotAcceptVisitor: aVisitor [

	100 timesRepeat: [ self doStuff ]
]

{ #category : #visitors }
SindarinTestObjectToVisit >> doStuff [

	^ self
]
