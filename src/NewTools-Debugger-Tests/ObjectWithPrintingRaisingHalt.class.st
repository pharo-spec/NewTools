Class {
	#name : #ObjectWithPrintingRaisingHalt,
	#superclass : #Object,
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #printing }
ObjectWithPrintingRaisingHalt >> printOn: aStream [

	<haltOrBreakpointForTesting>
	^ self halt
]
