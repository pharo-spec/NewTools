Class {
	#name : #StObjectWithPrintDoesNotUnderstand,
	#superclass : #Object,
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #printing }
StObjectWithPrintDoesNotUnderstand >> printOn: aString [

	^ self iShouldNotUnderstandThis
]
