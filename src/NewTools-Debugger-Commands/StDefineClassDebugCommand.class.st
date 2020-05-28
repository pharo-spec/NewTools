"
I request the debugger to define a missing class in case the current context is interrupted on a DNU exception and a receiver that is an unknown symbol
"
Class {
	#name : #StDefineClassDebugCommand,
	#superclass : #StDefineMissingEntityDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StDefineClassDebugCommand class >> defaultName [
	^ 'Create missing class'
]

{ #category : #testing }
StDefineClassDebugCommand >> appliesTo: aDebugger [
	^ aDebugger canExecuteCreateMissingClassCommand
]

{ #category : #executing }
StDefineClassDebugCommand >> execute [	
	self debugger createMissingClass
]
