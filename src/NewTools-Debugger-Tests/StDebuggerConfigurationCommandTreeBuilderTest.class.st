Class {
	#name : #StDebuggerConfigurationCommandTreeBuilderTest,
	#superclass : #StDebuggerToolCommandTreeBuilderTest,
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #'instance creation' }
StDebuggerConfigurationCommandTreeBuilderTest >> newBuilder [

	^ StDebuggerConfigurationCommandTreeBuilder
		  buildCommandsGroupWith: debugger
		  forRoot: rootGroup
]

{ #category : #tests }
StDebuggerConfigurationCommandTreeBuilderTest >> testConfigurationCommands [
	self
		assertCommandGroup: builder generalConfigurationCommandsGroup
		hasSameCommands: builder configurationCommandClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsSubMenu
]

{ #category : #tests }
StDebuggerConfigurationCommandTreeBuilderTest >> testConfigurationCommandsClasses [

	self assertCollection: builder configurationCommandClasses equals: {
			StDebuggerToggleFilterStackCommand.
			StDebuggerSettingsCommand }
]

{ #category : #tests }
StDebuggerConfigurationCommandTreeBuilderTest >> testDisplayStrategy [
	self
		assert: builder class displayStrategy
		equals: CmUIDisplayAsSubMenu
]

{ #category : #tests }
StDebuggerConfigurationCommandTreeBuilderTest >> testGroupDescription [
	self assert: builder class groupDescription equals: 'Debugger configuration actions'
]

{ #category : #tests }
StDebuggerConfigurationCommandTreeBuilderTest >> testGroupName [
	self assert: builder class groupName equals: 'Debugger configuration'
]
