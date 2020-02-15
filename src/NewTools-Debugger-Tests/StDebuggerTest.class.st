Class {
	#name : #StDebuggerTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugger'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - views'
}

{ #category : #'helpers - debugger control' }
StDebuggerTest >> clickStepInto [
	self debugger updateToolbar.
	(self debugger toolbar items detect:[:item| item label = 'Into']) click
]

{ #category : #'helpers - debugger control' }
StDebuggerTest >> clickStepInto: n [
	n timesRepeat: [ self clickStepInto ]
]

{ #category : #'helpers - debugger control' }
StDebuggerTest >> clickStepOver [
	self debugger updateToolbar.
	(self debugger toolbar items detect:[:item| item label = 'Over']) click
]

{ #category : #'helpers - debugger control' }
StDebuggerTest >> clickStepOver: n [
	n timesRepeat: [ self clickStepOver ]
]

{ #category : #accessing }
StDebuggerTest >> debugger [
	^ debugger ifNil: [ debugger := self debuggerClass basicNew ]
]

{ #category : #accessing }
StDebuggerTest >> debuggerClass [
	^ SpecDebugger
]

{ #category : #accessing }
StDebuggerTest >> debuggerOn: aDebugSession [
	^self debugger session: aDebugSession; initialize
]

{ #category : #accessing }
StDebuggerTest >> initializedDebugger [
	^ self debugger initialize
]

{ #category : #accessing }
StDebuggerTest >> inspectorTableFor: inspector [
	|contextInspector|
	contextInspector := (inspector class slotNamed: #contextInspector) read: inspector.
	^(contextInspector class slotNamed: #attributeTable) read: contextInspector
]

{ #category : #running }
StDebuggerTest >> setUp [
	| context process |
	super setUp.
	context := [ | i |
	i := 1 squared.
	i = 1
		ifTrue: [ | j |
			j := i + 1 ].
	^ 1 + i] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: context
]

{ #category : #running }
StDebuggerTest >> tearDown [
	session clear
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testCodeChangeAfterContextChange [
	self assert: false
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testCodeModification [
	self assert: false
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testCodeSelectionAfterStepOver [
	self assert: false
]

{ #category : #'tests - context inspector' }
StDebuggerTest >> testContextChangedAfterStepIn [ 
	| dbg |
	dbg := self debuggerOn: session.
	
	self clickStepInto. "We enter the block context"
	self assert: dbg contextInspector inspectedObject == session shortStack first.
	
	self clickStepInto. "We step into the first message"
	self assert: dbg contextInspector inspectedObject == session shortStack first.

]

{ #category : #'tests - context inspector' }
StDebuggerTest >> testContextChangedAfterStepOverAndReturn [
	| dbg currentContext |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentContext := dbg contextInspector inspectedObject.
	self clickStepOver: 2. "stepping over ^self * self (i.e. returning)"
	self
		deny: dbg contextInspector inspectedObject
		equals: currentContext
]

{ #category : #'tests - context inspector' }
StDebuggerTest >> testContextInspectorMenu [
	self assert: 1 @ 1 equals: 2 @ 2
]

{ #category : #'tests - context inspector' }
StDebuggerTest >> testContextTempVarList [
	| dbg contextItems inspectorTable|
	dbg := self debuggerOn: session.
	inspectorTable := self inspectorTableFor: dbg contextInspector.
	
	self clickStepInto: 5.	
	contextItems := inspectorTable roots.
	self assert: contextItems first rawValue equals: session shortStack first. "thisContext"
	self assert: contextItems second rawValue equals: 1. "stackTop"
	self assert: (contextItems detect:[:node| node key = #i]) rawValue equals: 1.
	
	
	"We add 2 to the num temps in the context inspector, 
	for the thisContext and the stackTop nodes"
	self
		assert: inspectorTable roots size
		equals: dbg contextInspector inspectedObject tempNames size + 2

]

{ #category : #'tests - context inspector' }
StDebuggerTest >> testContextUnchangedAfterStepOver [
	| dbg currentContext |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentContext := dbg contextInspector inspectedObject.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	self clickStepOver. 
	self assert: dbg contextInspector inspectedObject ==  currentContext
]

{ #category : #'tests - initialization' }
StDebuggerTest >> testDebuggerApplication [
	self assert: self debugger application identicalTo: SpecDebugger currentApplication 
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testDiscardCodeModification [
	self assert: false
]

{ #category : #'tests - extensions' }
StDebuggerTest >> testExtendedToolsClassesFor [
	self
		assertCollection:
			(SpecDebugger
				collectExtendedToolsPragmaFor: #debuggerExtensionTestPragma)
		includesAll: (StDebuggerDummyTestPresenter class>>#debuggerExtensionTestPragma) pragmas 
]

{ #category : #'tests - extensions' }
StDebuggerTest >> testExtendedToolsPragma [
	self assert: SpecDebugger extendedToolsPragma equals: #debuggerExtensionOrder:showByDefault:
]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testInspectorHeaderLabel [
	| dbg displayedLabel |
	dbg := self debuggerOn: session.
	displayedLabel := ((((dbg inspector instVarNamed: #inspector) 
		                     instVarNamed: #millerList) presenters first 
		                    instVarNamed: #header) instVarNamed: #titleLabel)
		                  label.
	self assert: (dbg inspector model labelString copyFrom: 1 to: 12) equals: 'Receiver in:'.	
	self assert: (displayedLabel copyFrom: 1 to: 12) equals: 'Receiver in:'.
]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testInspectorSelfBinding [
	| dbg evaluator receiver |
	dbg := self debuggerOn: session.
	evaluator := (dbg inspector instVarNamed: #inspector) millerList
		             presenters first evaluator.
	receiver := dbg inspector model inspectedObject context receiver.
	self assert: evaluator doItReceiver identicalTo: receiver.
	self assert: evaluator behavior identicalTo: receiver class
]

{ #category : #'tests - extensions' }
StDebuggerTest >> testInstantiateExtensionToolsPage [
	|dbg toolPage|
	dbg := self debugger.
	toolPage := dbg instantiateExtensionToolsPage: StDebuggerDummyTestPresenter.
	self assert: toolPage class identicalTo: SpNotebookPage.
	self assert: toolPage presenterProvider value class identicalTo: StDebuggerDummyTestPresenter.
	self assert: toolPage title equals: StDebuggerDummyTestPresenter debuggingExtensionToolName.
	self assertCollection: dbg extensionTools includesAll: { toolPage presenterProvider value}.
	 
]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverChangedAfterStepIn [ 
	| dbg |
	dbg := self debuggerOn: session.
	
	self clickStepInto. "We enter the block context"
	self assert: dbg inspector inspectedObject == session shortStack first receiver.
	
	self clickStepInto. "We step into the first message"
	self assert: dbg inspector inspectedObject == session shortStack first receiver.


]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverChangedAfterStepOverAndReturn [
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject.
	self clickStepOver: 2. "stepping over ^self * self (i.e. returning)"
	self
		deny: dbg inspector inspectedObject
		equals: currentReceiver
]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverInitialRawInspectionSelection [
]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverInspectorMenu [
	self assert: false.
	self flag: 'TODO'

]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverList [
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject.	
	self assert: currentReceiver equals: 1

]

{ #category : #'tests - receiver inspector' }
StDebuggerTest >> testReceiverUnchangedAfterStepOver [ 
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	self clickStepOver. 
	self assert: dbg inspector inspectedObject ==  currentReceiver

]

{ #category : #'tests - extensions' }
StDebuggerTest >> testRegisterExtensionTool [
	|dbg object|
	dbg := self debugger.
	self assertEmpty: dbg extensionTools.
	dbg registerExtensionTool: (object := Object new).
	self assert: dbg extensionTools size equals: 1.
	self assertCollection: dbg extensionTools includesAll: { object }
]

{ #category : #'tests - raw inspection' }
StDebuggerTest >> testRestoreReceiverRawInspectionSelection [
]

{ #category : #'tests - raw inspection' }
StDebuggerTest >> testRestoreReceiverRawInspectionSelectionAfterContextChange [
]

{ #category : #'tests - session' }
StDebuggerTest >> testReturnEnteredValue [
	self fail
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testSaveCodeModification [
	self assert: false
]

{ #category : #'tests - raw inspection' }
StDebuggerTest >> testSaveReceiverRawInspectionSelection [
]

{ #category : #'tests - raw inspection' }
StDebuggerTest >> testSaveReceiverRawInspectionSelectionAfterContextChange [
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testSelectLastStackElementWithMoreElements [
	| dbg stackTable selectedItem |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	
	self clickStepInto.
	self clickStepInto.
	stackTable items: (session stackOfSize: 1).
	
	self assert: stackTable items size equals: 1.
	self assert: stackTable items last equals: session stack first.	
		
	"As we select the last element of the stack table, 
	it should expand the size of the displayed stack"
	selectedItem := stackTable items last.
	stackTable selectItem: selectedItem.
	self assert: stackTable items size equals: session stack size.
	self assert: stackTable items equals: session stack.
	self assert: stackTable selection selectedItem identicalTo: selectedItem

	
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testSelectLastStackElementWithoutMoreElements [
	| dbg stackTable startingStackSize |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	startingStackSize := stackTable items size.
	stackTable selectItem: stackTable items last.
	
	self assert: stackTable items size equals: startingStackSize
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testSelectionMenu [
	self assert: false
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> testStackContextMenuStackEditionsCommands [
	| dbg stackTable |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	self
		assertCommandGroup: dbg stackContextMenuStackEditionsCommands
		hasSameCommands:
			(CmCommand
				commandClassesFromPragma: #StackContextMenuEditionDebugCommand)
		withContext: dbg
		displayStrategy: CmUIDisplayAsSubMenu
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> testStackContextNavigationCommands [
	| dbg stackTable cmdGroup commands|	
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	cmdGroup := dbg stackContextNavigationCommands.
	commands := cmdGroup decoratedGroup entries
		collect: [ :spCommand | spCommand decoratedCommand ].
		
	self deny: cmdGroup isRoot.
	
	self assert: commands first class identicalTo: SpBrowseClassCommand.
	self assert: commands first name equals: 'method'.
	self assert: commands first context identicalTo: stackTable selection selectedItem method.
	
	self assert: commands second class identicalTo: SpBrowseClassCommand.
	self assert: commands second name equals: 'receiver'.
	self assert: commands second context identicalTo: stackTable selection selectedItem receiver class.
	
	
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> testStackMethodNavigationCommands [
	| dbg stackTable |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	self
		assertCommandGroup: dbg stackMethodNavigationCommands
		hasSameCommands:
			{SpBrowseMethodInheritanceCommand.
			SpBrowseMethodVersionsCommand}
		withContext: stackTable selection selectedItem method
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> testStackMethodSelectorNavigationCommands [
	| dbg stackTable |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	self
		assertCommandGroup: dbg stackMethodSelectorNavigationCommands
		hasSameCommands:
			{SpBrowseImplementorsCommand.
			SpBrowseSendersCommand.
			SpBrowseMethodReferencesCommand}
		withContext: stackTable selection selectedItem method selector
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> testStackReceiverClassNavigationCommands [
	| dbg stackTable |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	self
		assertCommandGroup: dbg stackReceiverClassNavigationCommands
		hasSameCommands:
			{SpBrowseClassReferencesCommand.
			SpBrowseClassHierarchyCommand.
			SpBrowseClassVariablesCommand.
			SpBrowseClassVarRefsCommand.
			SpBrowseInstVarRefsCommand}
		withContext: stackTable selection selectedItem receiver class
		displayStrategy: CmUIDisplayAsGroup
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testStackTableAfterReturn [
	| dbg stackTableItems stackSizeAfterStepIn |
	dbg := self debuggerOn: session.

	"we dive into a method"
	self clickStepInto: 2.
	stackSizeAfterStepIn := dbg stackTable items size.

	"we return from it"
	self clickStepOver: 2.
	stackTableItems := dbg stackTable items.
	self assert: dbg stackTable selection selectedIndex equals: 1.
	self assert: dbg stackTable selection selectedItem identicalTo: session shortStack first.
	self assert: stackTableItems size equals: stackSizeAfterStepIn - 1.
	self assert: stackTableItems equals: session shortStack
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testStackTableAfterStepIn [
	| dbg stackTableItems startingStackSize |
	dbg := self debuggerOn: session.
	startingStackSize := dbg stackTable items size.
	self clickStepInto: 2.
	stackTableItems := dbg stackTable items.
	self assert: dbg stackTable selection selectedIndex equals: 1.
	self
		assert: dbg stackTable selection selectedItem == session shortStack first.
	self assert: stackTableItems size equals: startingStackSize + 1.
	self assert: stackTableItems equals: session shortStack
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testStackTableInitialization [
	self assert: self debugger stackTable isNil
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testStackTableSelectionChanged [
	| dbg |
	dbg := self debuggerOn: session.
	self clickStepInto: 2.
	dbg stackTable selectItem: dbg stackTable items second.
	self
		assert:
			dbg inspector inspectedObject context
				identicalTo: dbg stackTable selection selectedItem.
	self
		assert:
			dbg inspector inspectedObject context receiver
				identicalTo: dbg stackTable selection selectedItem receiver.
	self
		assert: dbg code text
		equals: dbg stackTable items second sourceCode
]

{ #category : #'tests - stack table' }
StDebuggerTest >> testStackTableWithNewSession [
	self debugger session: session.
	self
		assert: (self initializedDebugger stackTable) items
		equals: session shortStack.
	self
		assert: self debugger stackTable selection selectedIndex
		equals: 1.
	self
		assert:
			self debugger stackTable selection selectedItem
				identicalTo: session shortStack first
]

{ #category : #'tests - code pane' }
StDebuggerTest >> testUnauthorizedCodeModification [
	self assert: false
]

{ #category : #'tests - stack table context menu' }
StDebuggerTest >> teststackContextMenuExplorationCommands [
	| dbg stackTable cmdGroup cmdEntries |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	stackTable selectItem: stackTable items first.
	cmdGroup := dbg stackContextMenuExplorationCommands.
	cmdEntries := cmdGroup decoratedGroup entries collect:[:spCmd| spCmd decoratedCommand].
	self deny: cmdGroup isRoot.
	self assert: cmdEntries size equals: 3.
	self assert: cmdGroup name equals: 'Explore'.
	self
		assertCommandGroupEntries: cmdEntries
		hasCommands:
			{SpBrowseInstancesCommand.
			SpBrowseSubInstancesCommand.
			SpBrowsePointersToCommand}.
	self
		assertCommandGroup: cmdGroup
		hasDisplayStrategy: CmUIDisplayAsSubMenu.
	self
		assertCommands:
			{cmdEntries first.
			cmdEntries second}
		haveContext:  stackTable selection selectedItem receiver class .
	self
		assertCommands: {cmdEntries last}
		haveContext: stackTable selection selectedItem receiver 
]
