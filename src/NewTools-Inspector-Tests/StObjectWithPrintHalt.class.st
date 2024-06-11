Class {
	#name : 'StObjectWithPrintHalt',
	#superclass : 'Object',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'printing' }
StObjectWithPrintHalt >> printOn: aString [

	<haltOrBreakpointForTesting>

	^ self halt
]
