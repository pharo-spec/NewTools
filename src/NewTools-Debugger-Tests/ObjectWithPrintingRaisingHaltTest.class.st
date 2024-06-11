Class {
	#name : 'ObjectWithPrintingRaisingHaltTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
ObjectWithPrintingRaisingHaltTest >> testInspectingObjectWithPrintOnWithHaltOpenInspector [
	"Make sure that inspecting an object with a broken printOn: does not produce an endless loop.
	"
	
	| openInspectors inspectedObject |
	StInspectorPresenter allInstances select: [ :e | e window isOpen ] 
					thenDo: [ :each | each window close ].

	inspectedObject := ObjectWithPrintingRaisingHalt new.
	"We are using halt in printOn: because halt is an exception (not an error).
	The problem was that protecting with onErrorDo: does not catch all exception in particular 
	Halt. And catching Exception in general is not possible else we could break on any printOn: method 
	in the system."
	
	inspectedObject inspect.

	openInspectors := StInspectorPresenter allInstances select: [ :e | 
		                  e window isOpen ].

	self assert: openInspectors size equals: 1.

	self
		assert: openInspectors first model inspectedObject
		equals: inspectedObject.

	StInspectorPresenter allInstances do: [ :each | each delete ].
]
