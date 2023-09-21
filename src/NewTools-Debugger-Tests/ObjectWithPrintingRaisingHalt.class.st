Class {
	#name : 'ObjectWithPrintingRaisingHalt',
	#superclass : 'Object',
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'printing' }
ObjectWithPrintingRaisingHalt >> printOn: aStream [

	<haltOrBreakpointForTesting>
	^ self halt
]
