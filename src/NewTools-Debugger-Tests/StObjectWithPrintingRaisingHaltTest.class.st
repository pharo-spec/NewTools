Class {
	#name : 'StObjectWithPrintingRaisingHaltTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
StObjectWithPrintingRaisingHaltTest >> testInspectingObjectWithPrintOnWithHaltOpenInspector [
	"Make sure that inspecting an object with a broken printOn: does not produce an endless loop.
	"
	
	| inspectedObject window |
	
	inspectedObject := ObjectWithPrintingRaisingHalt new.
	"We are using halt in printOn: because halt is an exception (not an error).
	The problem was that protecting with onErrorDo: does not catch all exception in particular 
	Halt. And catching Exception in general is not possible else we could break on any printOn: method 
	in the system."
	
	window := StInspectorPresenter inspect: inspectedObject.

	self
		assert: window presenter model inspectedObject
		equals: inspectedObject.
		
	window delete
]
