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

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testCommandGroupStructure [
	|stackGroup|
	stackGroup := rootGroup groups first.	
	self assert: stackGroup entries size equals: 1.
	self assert: stackGroup groups first name equals: builder defaultDebugActionsGroupName.
	self assert: stackGroup groups first description equals: builder defaultDebugActionsDescription.
]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testToolbarDefaultActionsCommands [
	self
		assertCommandGroup: builder toolbarDefaultDebuggingCommands
		hasSameCommands: (builder defaultDebugCommands collect:[:c| c decoratedCommand class])
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]
