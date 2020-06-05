Class {
	#name : #StDebuggerToolbarCommandTreeBuilderTest,
	#superclass : #StDebuggerToolCommandTreeBuilderTest,
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #'instance creation' }
StDebuggerToolbarCommandTreeBuilderTest >> newBuilder [
	^ StDebuggerToolbarCommandTreeBuilder
		buildCommandsGroupWith: debugger
		forRoot: rootGroup
]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testBuildCommandGroupFromNamedDescription [
	| group spCommands |
	group := builder
		buildCommandGroupFrom:
			{StMockDebugCommand.
			StMockDebugCommand}
		named: #testName
		description: #testDescription.
	self assert: group name equals: #testName.	
	self assert: group description equals: #testDescription.
	spCommands := group allCommands.
	self assert: spCommands size equals: 2.
	self assert: spCommands first decoratedCommand class equals: StMockDebugCommand.
	self assert: spCommands second decoratedCommand class equals: StMockDebugCommand.
	self assert: spCommands first context identicalTo: debugger.
	self assert: spCommands second context identicalTo: debugger
]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testCommandGroupStructure [
	|stackGroup|
	stackGroup := rootGroup groups first.	
	self assert: stackGroup entries size equals: 3.
	self assert: stackGroup groups first name equals: builder executionControlGroupName.
	self assert: stackGroup groups first description equals: builder executionControlGroupDescription.
	self assert: stackGroup groups second name equals: builder contextRequestGroupName.
	self assert: stackGroup groups second description equals: builder contextRequestGroupDescription.
	self assert: stackGroup groups third name equals: builder contextControlGroupName.
	self assert: stackGroup groups third description equals: builder contextControlGroupDescription.

]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testContextControlDebuggingCommands [
	self
		assertCommandGroup: builder contextControlDebuggingCommands
		hasSameCommands: builder contextControlCommandClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testContextRequestDebuggingCommands [
	self
		assertCommandGroup: builder contextRequestDebuggingCommands
		hasSameCommands: builder contextRequestCommandClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerToolbarCommandTreeBuilderTest >> testExecutionControlDebuggingCommands [
	self
		assertCommandGroup: builder executionControlDebuggingCommands
		hasSameCommands: builder executionControlCommandClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]
