Class {
	#name : #StDebuggerStackCommandTreeBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugger',
		'rootGroup',
		'builder'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #assertions }
StDebuggerStackCommandTreeBuilderTest >> assertCommandGroup: cmdGroup hasDisplayStrategy: displayStrategy [
	self
		assert: cmdGroup displayStrategy class
		identicalTo: displayStrategy
]

{ #category : #assertions }
StDebuggerStackCommandTreeBuilderTest >> assertCommandGroup: cmdGroup hasSameCommands: expectedCommands withContext: expectedContext displayStrategy: displayStrategy [
	| commands |
	self deny: cmdGroup isRoot.
	self assertCommandGroup: cmdGroup hasDisplayStrategy: displayStrategy.
	commands := cmdGroup allCommands
		collect: [ :spCommand | spCommand decoratedCommand ].
	self
		assertCommandGroupEntries: commands
		hasCommands: expectedCommands.
	self assertCommands: commands haveContext: expectedContext
]

{ #category : #assertions }
StDebuggerStackCommandTreeBuilderTest >> assertCommandGroupEntries: commands hasCommands: expectedCommands [
	self
		assertCollection: (commands collect: [ :cmd | cmd class ])
		hasSameElements: expectedCommands
]

{ #category : #assertions }
StDebuggerStackCommandTreeBuilderTest >> assertCommands: commands equals: expectedCommands [
	self assert: commands size equals: expectedCommands size.
	commands
		with: expectedCommands
		do: [ :actual :expected | 
			self assert: actual name equals: expected name.
			self assert: actual context identicalTo: expected context.
			self assert: actual class identicalTo: expected class ]
]

{ #category : #assertions }
StDebuggerStackCommandTreeBuilderTest >> assertCommands: commands haveContext: expectedContext [
	commands
		do: [ :cmd | self assert: cmd context identicalTo: expectedContext ]
]

{ #category : #helper }
StDebuggerStackCommandTreeBuilderTest >> commandsFromSpecGroup: group [
	^ group decoratedGroup entries collect: [ :cmd | cmd decoratedCommand ]
]

{ #category : #helper }
StDebuggerStackCommandTreeBuilderTest >> newBuilder [
	^ StDebuggerStackCommandTreeBuilder
		buildCommandsGroupWith: debugger
		forRoot: rootGroup
]

{ #category : #running }
StDebuggerStackCommandTreeBuilderTest >> setUp [
	| context process |
	super setUp.
	context := [ ^1 + 1 ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: context.
	debugger := SpecDebugger basicNew
		session: session;
		initialize.
	debugger stackTable selectItem: debugger stackTable items first.
	rootGroup := (CmCommandGroup named: 'root') asSpecGroup.
	builder := self newBuilder
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testBuildDebuggerCommandGroup [
	|stackGroup|
	self assert: rootGroup entries size equals: 1.
	stackGroup := rootGroup groups first.
	self assert: stackGroup name equals: builder class groupName.
	self assert: stackGroup description equals: builder class groupDescription.
	self assert: stackGroup entries size equals: 4.
	self assert: stackGroup groups first name equals: builder stackContextMenuActionsGroupName.
	self assert: stackGroup groups first description equals: builder stackContextMenuActionsDescription.
	self assert: stackGroup groups second name equals: builder browseGroupName.
	self assert: stackGroup groups second description equals: builder browseGroupDescription.
	self assert: stackGroup groups third name equals: builder stackContextMenuExplorationGroupName.
	self assert: stackGroup groups third description equals: builder stackContextMenuExplorationDescription.
	self assert: stackGroup groups fourth name equals: builder stackGroupName.
	self assert: stackGroup groups fourth description equals: builder stackGroupDescription
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
