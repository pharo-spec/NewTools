Class {
	#name : #ObjectWithPrintingRaisingHaltTest,
	#superclass : #TestCase,
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #tests }
ObjectWithPrintingRaisingHaltTest >> testInspectingObjectWithPrintOnWithHaltOpenInspector [
	"Make sure that inspecting an object with a broken printOn: does not produce an endless loop.
	"
	
	| openInspectors inspectedObject |
	StInspector allInstances select: [ :e | e window isOpen ] 
					thenDo: [ :each | each window close ].

	inspectedObject := ObjectWithPrintingRaisingHalt new.
	"We are using halt in printOn: because halt is an exception (not an error).
	The problem was that protecting with onErrorDo: does not catch all exception in particular 
	Halt. And catching Exception in general is not possible else we could break on any printOn: method 
	in the system."
	
	inspectedObject inspect.

	openInspectors := StInspector allInstances select: [ :e | 
		                  e window isOpen ].

	self assert: openInspectors size equals: 1.

	self
		assert: openInspectors first model inspectedObject
		equals: inspectedObject.

	StInspector allInstances do: [ :each | each delete ].
]
