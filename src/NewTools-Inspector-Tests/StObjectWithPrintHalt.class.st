Class {
	#name : #StObjectWithPrintHalt,
	#superclass : #Object,
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #printing }
StObjectWithPrintHalt >> printOn: aString [

	^ self halt
]
