Class {
	#name : #StDebuggerCodeCommandTreeBuilderTest,
	#superclass : #StDebuggerToolCommandTreeBuilderTest,
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #'instance creation' }
StDebuggerCodeCommandTreeBuilderTest >> newBuilder [
	^ StDebuggerCodeCommandTreeBuilder
		buildCommandsGroupWith: debugger
		forRoot: rootGroup
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testCodeDebugCommandsDescription [
	self assert: builder  codeDebugCommandsDescription equals: 'Execution control'
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testCodeDebugCommandsGroupName [
	self assert: builder  codeDebugCommandsGroupName equals: 'Execution'
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testCodeExecutionControlCommandsClasses [
	self
		assertCollection: builder codeExecutionControlCommandsClasses
		equals: {StRunToSelectionCommand}
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testCodeExtensionCommandsClasses [
	| classes |
	self flag: '#DBG_IMPROVE'.
	"This test basically reproduce the same code than in the command builder class.
	Not nice, but at least specifies what commands classes should be returned by the builder."
	classes := (PragmaCollector
		filter: [ :prg | prg selector = #codeExtensionDebugCommand: ]) reset
		collected collect: [ :prg | prg methodClass soleInstance ].
	self
		assertCollection: builder codeExtensionCommandsClasses
		equals: classes
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testDisplayStrategy [
	self assert: builder class displayStrategy equals: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testGroupDescription [
	self assert: builder class groupDescription equals: 'Debug actions from code'
]

{ #category : #tests }
StDebuggerCodeCommandTreeBuilderTest >> testGroupName [
	self assert: builder class groupName equals: 'Code'
]
