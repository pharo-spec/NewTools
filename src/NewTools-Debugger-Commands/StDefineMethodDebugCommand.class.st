"
I request the debugger to define a missing method in case the current context is interrupted on a DNU exception
"
Class {
	#name : #StDefineMethodDebugCommand,
	#superclass : #StDefineMissingEntityDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StDefineMethodDebugCommand class >> defaultName [
	^ 'Create missing command'
]

{ #category : #testing }
StDefineMethodDebugCommand >> appliesTo: aDebugger [
	^ aDebugger canExecuteCreateMissingMethodCommand
]

{ #category : #hooks }
StDefineMethodDebugCommand >> execute [
	self debugger createMissingMethod
]
