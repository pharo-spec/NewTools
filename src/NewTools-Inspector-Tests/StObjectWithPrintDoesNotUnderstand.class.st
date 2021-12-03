Class {
	#name : #StObjectWithPrintDoesNotUnderstand,
	#superclass : #Object,
	#instVars : [
		'selector'
	],
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #'instance creation' }
StObjectWithPrintDoesNotUnderstand class >> withMissingMessageSelector: aString [ 
	^ self new missingMessageSelector: aString
]

{ #category : #accessing }
StObjectWithPrintDoesNotUnderstand >> missingMessageSelector: aString [ 
	selector := aString
]

{ #category : #printing }
StObjectWithPrintDoesNotUnderstand >> printOn: aString [

	^ self perform: selector
]
