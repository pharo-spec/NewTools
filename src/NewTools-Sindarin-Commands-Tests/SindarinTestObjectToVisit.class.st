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
SindarinTestObjectToVisit >> acceptVisitorNeverFinishes: aVisitor [

	10000 timesRepeat: [ self doStuff ]
]

{ #category : #visitors }
SindarinTestObjectToVisit >> acceptVisitorWithError: visitor [

	visitor dnu
  
]

{ #category : #visitors }
SindarinTestObjectToVisit >> doNotAcceptVisitor: aVisitor [

	10 timesRepeat: [ self doStuff ]
]

{ #category : #visitors }
SindarinTestObjectToVisit >> doStuff [

	^ self
]
