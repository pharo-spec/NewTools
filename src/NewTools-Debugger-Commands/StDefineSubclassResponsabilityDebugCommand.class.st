"
I request the debugger to define a subclass responsibility method, in case the current context is interrupted on a subclass responsibility exception
"
Class {
	#name : #StDefineSubclassResponsabilityDebugCommand,
	#superclass : #StDefineMissingEntityDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StDefineSubclassResponsabilityDebugCommand class >> defaultDescription [
	^ 'Create a method in a class having the responsability to implement it.'
]

{ #category : #initialization }
StDefineSubclassResponsabilityDebugCommand class >> defaultIconName [
	^ #changeAdd
]

{ #category : #accessing }
StDefineSubclassResponsabilityDebugCommand class >> defaultName [
	^ 'Create subclass responsibility'
]

{ #category : #initialization }
StDefineSubclassResponsabilityDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #testing }
StDefineSubclassResponsabilityDebugCommand >> appliesTo: aDebugger [
	^ aDebugger canExecuteCreateSubclassResponsibilityCommand
]

{ #category : #actions }
StDefineSubclassResponsabilityDebugCommand >> execute [
	self debugger createSubclassResponsibility
]
