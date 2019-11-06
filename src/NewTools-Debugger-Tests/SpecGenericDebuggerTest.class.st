Class {
	#name : #SpecGenericDebuggerTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugger'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #'helpers - debugger control' }
SpecGenericDebuggerTest >> clickStepInto [
	self debugger updateToolbar.
	(self debugger toolbar items detect:[:item| item label = 'Into']) click
]

{ #category : #'helpers - debugger control' }
SpecGenericDebuggerTest >> clickStepInto: n [
	n timesRepeat: [ self clickStepInto ]
]

{ #category : #'helpers - debugger control' }
SpecGenericDebuggerTest >> clickStepOver [
	self debugger updateToolbar.
	(self debugger toolbar items detect:[:item| item label = 'Over']) click
]

{ #category : #'helpers - debugger control' }
SpecGenericDebuggerTest >> clickStepOver: n [
	n timesRepeat: [ self clickStepOver ]
]

{ #category : #accessing }
SpecGenericDebuggerTest >> debugger [
	^ debugger ifNil: [ debugger := self debuggerClass basicNew ]
]

{ #category : #accessing }
SpecGenericDebuggerTest >> debuggerClass [
	^ SpecDebugger
]

{ #category : #accessing }
SpecGenericDebuggerTest >> debuggerOn: aDebugSession [
	^self debugger session: aDebugSession; initialize
]

{ #category : #accessing }
SpecGenericDebuggerTest >> initializedDebugger [
	^ self debugger initialize
]

{ #category : #accessing }
SpecGenericDebuggerTest >> inspectorTableFor: inspector [
	|contextInspector|
	contextInspector := (inspector class slotNamed: #contextInspector) read: inspector.
	^(contextInspector class slotNamed: #attributeTable) read: contextInspector
]

{ #category : #running }
SpecGenericDebuggerTest >> setUp [
	| context process |
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
SpecGenericDebuggerTest >> tearDown [
	session clear
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testCodeChangeAfterContextChange [
	self assert: false
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testCodeModification [
	self assert: false
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testCodeSelectionAfterStepOver [
	self assert: false
]

{ #category : #'tests - context inspector' }
SpecGenericDebuggerTest >> testContextChangedAfterStepIn [ 
	| dbg |
	dbg := self debuggerOn: session.
	
	self clickStepInto. "We enter the block context"
	self assert: dbg contextInspector inspectedObject == session shortStack first.
	
	self clickStepInto. "We step into the first message"
	self assert: dbg contextInspector inspectedObject == session shortStack first.

]

{ #category : #'tests - context inspector' }
SpecGenericDebuggerTest >> testContextChangedAfterStepOverAndReturn [
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
SpecGenericDebuggerTest >> testContextInspectorMenu [
	self assert: false.
	self flag: 'TODO'

]

{ #category : #'tests - context inspector' }
SpecGenericDebuggerTest >> testContextTempVarList [
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
SpecGenericDebuggerTest >> testContextUnchangedAfterStepOver [
	| dbg currentContext |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentContext := dbg contextInspector inspectedObject.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	self clickStepOver. 
	self assert: dbg contextInspector inspectedObject ==  currentContext
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testDiscardCodeModification [
	self assert: false
]

{ #category : #'tests - receiver inspector' }
SpecGenericDebuggerTest >> testReceiverChangedAfterStepIn [ 
	| dbg |
	dbg := self debuggerOn: session.
	
	self clickStepInto. "We enter the block context"
	self assert: dbg receiverInspector inspectedObject == session shortStack first receiver.
	
	self clickStepInto. "We step into the first message"
	self assert: dbg receiverInspector inspectedObject == session shortStack first receiver.


]

{ #category : #'tests - receiver inspector' }
SpecGenericDebuggerTest >> testReceiverChangedAfterStepOverAndReturn [
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg receiverInspector inspectedObject.
	self clickStepOver: 2. "stepping over ^self * self (i.e. returning)"
	self
		deny: dbg receiverInspector inspectedObject
		equals: currentReceiver
]

{ #category : #'tests - receiver inspector' }
SpecGenericDebuggerTest >> testReceiverInspectorMenu [
	self assert: false.
	self flag: 'TODO'

]

{ #category : #'tests - receiver inspector' }
SpecGenericDebuggerTest >> testReceiverList [
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg receiverInspector inspectedObject.	
	self assert: currentReceiver equals: 1

]

{ #category : #'tests - receiver inspector' }
SpecGenericDebuggerTest >> testReceiverUnchangedAfterStepOver [ 
	| dbg currentReceiver |
	dbg := self debuggerOn: session.	
	
	self clickStepInto: 2. "getting into Number>>squared"
	currentReceiver := dbg receiverInspector inspectedObject.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	self clickStepOver. 
	self assert: dbg receiverInspector inspectedObject ==  currentReceiver

]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testSaveCodeModification [
	self assert: false
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testSelectLastStackElementWithMoreElements [
	| dbg stackTable |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	
	self clickStepInto.
	self clickStepInto.
	stackTable items: (session stackOfSize: 1).
	
	self assert: stackTable items size equals: 1.
	self assert: stackTable items last equals: session stack first.
	stackTable selectItem: stackTable items last.

	self assert: stackTable items size equals: session stack size.
	self assert: stackTable items equals: session stack.
	
	
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testSelectLastStackElementWithoutMoreElements [
	| dbg stackTable startingStackSize |
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	startingStackSize := stackTable items size.
	stackTable selectItem: stackTable items last.
	
	self assert: stackTable items size equals: startingStackSize
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testSelectionMenu [
	self assert: false
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testStackTableAfterReturn [
	| dbg stackTableItems stackSizeAfterStepIn |
	dbg := self debuggerOn: session.

	"we dive into a method"
	self clickStepInto: 2.
	stackSizeAfterStepIn := dbg stackTable items size.

	"we return from it"
	self clickStepOver: 2.
	stackTableItems := dbg stackTable items.
	self assert: dbg stackTable selection selectedIndex equals: 1.
	self
		assert: dbg stackTable selection selectedItem == session shortStack first.
	self assert: stackTableItems size equals: stackSizeAfterStepIn - 1.
	self assert: stackTableItems equals: session shortStack
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testStackTableAfterStepIn [
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
SpecGenericDebuggerTest >> testStackTableInitialization [

	self assert: (self debuggerOn: DebugSession new) stackTable items isEmpty
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testStackTableSelectionChanged [
	| dbg |
	dbg := self debuggerOn: session.
	self clickStepInto: 2.
	dbg stackTable selectItem: dbg stackTable items second.
	self
		assert:
			dbg contextInspector inspectedObject
				== dbg stackTable selection selectedItem.
	self
		assert:
			dbg receiverInspector inspectedObject
				== dbg stackTable selection selectedItem receiver.
	self
		assert: dbg code text
		equals: dbg stackTable items second sourceCode
]

{ #category : #'tests - stack table' }
SpecGenericDebuggerTest >> testStackTableWithNewSession [
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
				== session shortStack first
]

{ #category : #'tests - code pane' }
SpecGenericDebuggerTest >> testUnauthorizedCodeModification [
	self assert: false
]
