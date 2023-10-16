Class {
	#name : 'StObjectWithPrintError',
	#superclass : 'Object',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'printing' }
StObjectWithPrintError >> printOn: aString [

	^ self error: 'Some error message'
]
