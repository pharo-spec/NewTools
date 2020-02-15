Class {
	#name : #StDebuggerStackCommandTreeBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugger',
		'rootGroup'
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
	commands := cmdGroup decoratedGroup entries
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

{ #category : #'tests - stack table context menu' }
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
	rootGroup := (CmCommandGroup named: 'root') asSpecGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuActionsCommands [
	self flag: 'Stuff to break here'.
	self
		assertCommandGroup: self newBuilder stackContextMenuActionsCommands
		hasSameCommands:
			(CmCommand commandClassesFromPragma: #StackContextMenuActionsCommand)
		withContext: debugger
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #tests }
StDebuggerStackCommandTreeBuilderTest >> testStackContextMenuNavigationCommands [
	|builder cmdGroup groups cmdEntries expectedEntries|	
	
	builder := self newBuilder.
	cmdGroup := builder stackContextMenuNavigationCommands.
	groups := cmdGroup groups.
	
	self deny: cmdGroup isRoot.
	self assert: groups size equals: 4.
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
