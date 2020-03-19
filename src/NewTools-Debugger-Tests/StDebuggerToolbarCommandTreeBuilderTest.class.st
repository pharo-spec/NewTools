Class {
	#name : #StDebuggerToolbarCommandTreeBuilderTest,
	#superclass : #StDebuggerToolCommandTreeBuilderTest,
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #'instance creation' }
StDebuggerToolbarCommandTreeBuilderTest >> newBuilder [
	^ StDebuggerToolbarCommandTreeBuilder
		buildCommandsGroupWith: debugger
		forRoot: rootGroup
]
