Class {
	#name : #StDebuggerStackCommandTreeBuilderTest,
	#superclass : #StDebuggerToolCommandTreeBuilderTest,
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #helper }
StDebuggerStackCommandTreeBuilderTest >> newBuilder [
	^ StDebuggerStackCommandTreeBuilder
		buildCommandsGroupWith: debugger
		forRoot: rootGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testCommandGroupStructure [
	|stackGroup|
	stackGroup := rootGroup groups first.	
	self assert: stackGroup entries size equals: 4.
	self assert: stackGroup groups first name equals: builder browseGroupName.
	self assert: stackGroup groups first description equals: builder browseGroupDescription.
	self assert: stackGroup groups second name equals: builder stackContextMenuExplorationGroupName.
	self assert: stackGroup groups second description equals: builder stackContextMenuExplorationDescription.
	self assert: stackGroup groups third name equals: builder stackGroupName.
	self assert: stackGroup groups third description equals: builder stackGroupDescription.
	self assert: stackGroup groups fourth name equals: builder stackContextMenuActionsGroupName.
	self assert: stackGroup groups fourth description equals: builder stackContextMenuActionsDescription.
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testNavigationCommandForContext [
	|cmd|
	cmd := builder navigationCommand: StMockDebugCommand forContext: self.
	self assert: cmd decoratedCommand class identicalTo: StMockDebugCommand.
	self assert: cmd context identicalTo: self
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuActionsCommands [
	self
		assertCommandGroup: builder stackContextMenuActionsCommands
		hasSameCommands: builder stackActionsCommandsClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuBrowseCommands [
	|cmdGroup cmdEntries expectedEntries|	

	cmdGroup := builder stackContextMenuBrowseCommands.
	
	self deny: cmdGroup isRoot.
	self assert: cmdGroup groups size equals: 4.
	self assert: cmdGroup name equals: builder browseGroupName.
	self assert: cmdGroup description equals: builder browseGroupDescription.
	self assert: cmdGroup displayStrategy class identicalTo: CmUIDisplayAsSubMenu.
	
	cmdEntries := self commandsFromSpecGroup: (cmdGroup / builder stackContextNavigationGroupName).
	expectedEntries := self commandsFromSpecGroup: builder stackContextNavigationCommands. 	
	self assertCommands: cmdEntries equals: expectedEntries.
	
	cmdEntries := self commandsFromSpecGroup: (cmdGroup / builder stackMethodNavigationGroupName).
	expectedEntries := self commandsFromSpecGroup: builder stackMethodNavigationCommands. 	
	self assertCommands: cmdEntries equals: expectedEntries.
	
	cmdEntries := self commandsFromSpecGroup: (cmdGroup / builder stackMethodSelectorNavigationGroupName).
	expectedEntries := self commandsFromSpecGroup: builder stackMethodSelectorNavigationCommands. 	
	self assertCommands: cmdEntries equals: expectedEntries.
	
	cmdEntries := self commandsFromSpecGroup: (cmdGroup / builder stackReceiverClassNavigationGroupName).
	expectedEntries := self commandsFromSpecGroup: builder stackReceiverClassNavigationCommands. 	
	self assertCommands: cmdEntries equals: expectedEntries
	
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuExplorationCommands [
	|  cmdGroup cmdEntries |
	cmdGroup := builder stackContextMenuExplorationCommands.
	cmdEntries := cmdGroup allCommands collect:[:spCmd| spCmd decoratedCommand].
	self deny: cmdGroup isRoot.
	self assert: cmdEntries size equals: 3.
	self assert: cmdGroup name equals: builder stackContextMenuExplorationGroupName.
	self assert: cmdGroup description equals: builder stackContextMenuExplorationDescription.
	self
		assertCommandGroupEntries: cmdEntries
		hasCommands: 	builder stackExplorationCommandsClasses.
	self
		assertCommandGroup: cmdGroup
		hasDisplayStrategy: CmUIDisplayAsSubMenu.
	self
		assertCommands:
			{cmdEntries first.
			cmdEntries second}
		haveContext: debugger stackTable selection selectedItem receiver class.
	self
		assertCommands: {cmdEntries last}
		haveContext: debugger stackTable selection selectedItem receiver 
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuStackEditionsCommands [
	self
		assertCommandGroup: builder stackContextMenuStackEditionsCommands
		hasSameCommands: builder stackEditionCommandsClasses
		withContext: debugger
		displayStrategy: CmUIDisplayAsSubMenu
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextNavigationCommands [
	|cmdGroup commands|
	cmdGroup := builder stackContextNavigationCommands.
	commands := cmdGroup allCommands
		collect: [ :spCommand | spCommand decoratedCommand ].
		
	self deny: cmdGroup isRoot.
	
	self assert: commands first class identicalTo: SpBrowseClassCommand.
	self assert: commands first name equals: 'method'.
	self assert: commands first context identicalTo: debugger stackTable selection selectedItem method.
	
	self assert: commands second class identicalTo: SpBrowseClassCommand.
	self assert: commands second name equals: 'receiver'.
	self assert: commands second context identicalTo: debugger stackTable selection selectedItem receiver class
	
	
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackMethodNavigationCommands [
	self
		assertCommandGroup: builder stackMethodNavigationCommands
		hasSameCommands: builder stackMethodCommandsClasses
		withContext: debugger stackTable selection selectedItem method
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackMethodSelectorNavigationCommands [
	self
		assertCommandGroup: builder stackMethodSelectorNavigationCommands
		hasSameCommands: builder stackMethodSelectorCommandsClasses
		withContext: debugger stackTable selection selectedItem method selector
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackReceiverClassNavigationCommands [
	self
		assertCommandGroup: builder stackReceiverClassNavigationCommands
		hasSameCommands: builder stackReceiverCommandsClasses
		withContext: debugger stackTable selection selectedItem receiver class
		displayStrategy: CmUIDisplayAsGroup
]
