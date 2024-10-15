Class {
	#name : 'StDebuggerTest',
	#superclass : 'SpBaseTest',
	#instVars : [
		'session',
		'debugger',
		'dbg',
		'stackSizeBefore',
		'shouldFilterStack',
		'oldMethodToSourceDictionary',
		'lastUserPreservation',
		'lastUserPosition',
		'lastUserExtent'
	],
	#category : 'NewTools-Debugger-Tests-Presenters',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
StDebuggerTest >> debugger [
	^ debugger ifNil: [ debugger := self debuggerClass basicNew ]
]

{ #category : 'accessing' }
StDebuggerTest >> debuggerClass [
	^ StDebugger
]

{ #category : 'accessing' }
StDebuggerTest >> debuggerOn: aDebugSession [

	^ self debugger
		  session: aDebugSession;
		  application: self debuggerClass currentApplication;
		  initialize;
		  yourself
]

{ #category : 'accessing' }
StDebuggerTest >> executionControlCommandFrom: aDebugger [

	^ debugger toolbar leftItems select: [ :p | 
		  #( 'Proceed' 'Into' 'Over' 'Through' ) includes: p label ]
]

{ #category : 'accessing' }
StDebuggerTest >> initializedDebugger [

	dbg := self debugger.
	dbg application: self debuggerClass currentApplication.
	dbg initialize.

	^ dbg
]

{ #category : 'accessing' }
StDebuggerTest >> inspectorTableFor: inspector [
	|contextInspector|
	contextInspector := (inspector class slotNamed: #contextInspector) read: inspector.
	^(contextInspector class slotNamed: #attributeTable) read: contextInspector
]

{ #category : 'tests - accepting faulty code' }
StDebuggerTest >> replaceMethodWithQuickMethodStepping [

	"True is a good default value. We step into always by default"

	| context newSource callerContext |
	dbg := StTestDebuggerProvider new debuggerWithObjectHalting.
	dbg
		application: dbg class currentApplication;
		initialize;
		buildContextMenus.

	"Track the size of the stack before compiling the new method for later checking"
	context := dbg stackTable items first. 
	
	"We tell the parent that we did not want to step into"
	stackSizeBefore := context stack size.
	callerContext := context sender.

	newSource := 'haltingMethod ^ 1'.
	dbg code type: newSource.
	dbg code update.
	dbg acceptCodeChanges: newSource forContext: context.
	dbg debuggerActionModel updateIfAble 
]

{ #category : 'running' }
StDebuggerTest >> setUp [	
	super setUp.	
	session := StTestDebuggerProvider new sessionForDebuggerTests.
	shouldFilterStack := StDebuggerActionModel shouldFilterStack.
	oldMethodToSourceDictionary := Dictionary new.
	
	lastUserPreservation := self settings preserveWindowPositionAndExtent.
	"Save the user position (test running should not modify user changes)"
	lastUserPosition := self settings lastKnownPosition.
	"Save the user extent (test running should not modify user changes)"
	lastUserExtent := self settings lastKnownExtent.
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> settings [

	^ StDebugger settings
]

{ #category : 'accessing' }
StDebuggerTest >> subscriptionsForStDebuggerExtensionActivationToggle [

	| subscriptions |
	subscriptions := self class codeSupportAnnouncer subscriptions subscriptions.
	^ subscriptions asOrderedCollection select: [ :s | s announcementClass = StDebuggerExtensionActivationToggle ]
]

{ #category : 'running' }
StDebuggerTest >> tearDown [

	session clear.

	"In tests, should we use `debugger` when we need a fully initialized debugger and `dbg` when we just need a debugger created with #basicNew? Still, isn't it weird to clear the session only for a fully initialized debugger but not for a debugger created with #basicNew? Both have a session. Maybe this implies that `dbg`  should only use the instance variable `session` and nothing else. These specifications should be written somewhere, in the doc of the class maybe."
	debugger ifNotNil: [
		debugger close.
		debugger unsubscribeFromSystemAnnouncer.
		debugger debuggerActionModel ifNotNil: [ :actionModel |
			actionModel clear.
			actionModel session ifNotNil: [ :s | s clear ] ] ].

	StTestDebuggerProvider removeSelector: #foobar.
	StDebuggerObjectForTests
		compile:
		'haltingMethod <haltOrBreakpointForTesting> self halt. ^self'
		classified: 'util'.

	StDebuggerActionModel shouldFilterStack: shouldFilterStack.
	StTestDebuggerProvider removeSelector: #foobar.
	oldMethodToSourceDictionary	associationsDo: [ :assoc |
		assoc key methodClass
			compile: assoc value
			classified: assoc key protocolName ].
		
	"Restore the original preservation setting"		
	self settings preserveWindowPositionAndExtent: lastUserPreservation.
	"Restore the original position"		
	self settings lastKnownPosition: lastUserPosition.
	"Restore the original extent"		
	self settings lastKnownExtent: lastUserExtent.

	super tearDown
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testAcceptCodeChangesForContext [
	| context newSource |
	
	dbg := StTestDebuggerProvider new debuggerWithObjectHalting.
	dbg
		application: dbg class currentApplication;
		initialize;
		buildContextMenus.
	context := dbg stackTable items first.
	newSource := 'haltingMethod ^1+1 squared'.	
	dbg code type: newSource.
	dbg code update.
	dbg unsavedCodeChanges at: 4 put: 2.
	
	dbg acceptCodeChanges: newSource forContext: context.
	self assertEmpty: dbg unsavedCodeChanges.
	self assert: dbg code text equals: newSource
]

{ #category : 'tests' }
StDebuggerTest >> testActionModelSubscription [

	self assert: self debugger debuggerActionModel isNil.

	debugger session: session.

	self assert: debugger debuggerActionModel isNotNil.
	self assert:
		(debugger debuggerActionModel hasSubscriber: debugger).

	debugger unsubscribeFromActionModel.

	self deny:
		(debugger debuggerActionModel hasSubscriber: debugger)
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testCancelCodeChangesFor [
	| firstContext lastContext |
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	firstContext := dbg stackTable items first.	
	lastContext := dbg stackTable items last.		
	dbg code type: 'a'.
	dbg code update.
	dbg stackTable selectItem: lastContext.
	
	self assert: (dbg unsavedCodeChangesFor: firstContext) equals: 'a'.
	dbg stackTable selectItem: firstContext.
	
	dbg code triggerResetAction.
	self should: [ (dbg unsavedCodeChangesFor: firstContext) ] raise: KeyNotFound.
	self assert: dbg code text equals: firstContext sourceCode
	
	
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testClearUnsavedChanges [

	dbg := self debuggerOn: session.
	dbg unsavedCodeChanges at: 4 put: 2.
	dbg clearUnsavedCodeChanges.
	self assertEmpty: dbg unsavedCodeChanges
]

{ #category : 'tests - actions' }
StDebuggerTest >> testClose [

	| windowPresenter actionModel |
	windowPresenter := SpWindowPresenter new.
	windowPresenter windowIsOpened.
	debugger := self debuggerOn: session.
	actionModel := debugger debuggerActionModel.
	windowPresenter presenter: debugger.

	"We trigger the closing from the presenter instead of the debugger itself,
	because the window is not really open so the debugger will not close through debugger close."
	windowPresenter windowClosed.
	self deny: (self class codeSupportAnnouncer hasSubscriber: debugger).
	self deny: (actionModel hasSubscriber: debugger)
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testCodeChangeAfterContextChange [
	| firstContext lastContext |
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	firstContext := dbg stackTable items first.	
	lastContext := dbg stackTable items last.	
	
	self assert: dbg code text equals: firstContext sourceCode.
	dbg stackTable selectItem: lastContext.
	self assert: dbg code text equals: lastContext sourceCode.
	dbg stackTable selectItem: firstContext.
	self assert: dbg code text equals: firstContext sourceCode.
	
	self should: [ dbg unsavedCodeChangesFor:  firstContext] raise: KeyNotFound.	
	self should: [ dbg unsavedCodeChangesFor:  lastContext] raise: KeyNotFound
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testCodeSelectionAfterRestart [
	| adapter segments highlightSegment pcRangeForContext |
	
	dbg := self debuggerOn: session.
	adapter := SpMorphicCodeAdapter new.
	adapter adapt: dbg code.	
	dbg code adapter: adapter.
	dbg code adapter buildWidget.	
	dbg
		stepInto;
		stepInto.
	dbg restartCurrentContext.
	
	pcRangeForContext := (session pcRangeForContext: dbg currentContext).
	segments := dbg code adapter widget segments.
	self assert: segments size equals: 1.
	highlightSegment := segments first.	
	
	self
		assert:  (highlightSegment firstIndex to: highlightSegment lastIndex)
		equals: (pcRangeForContext first to: pcRangeForContext last + 1)
	"The pc range is highlighted with an additionnal index to encompass the full text of the node (why?)"
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testCodeSelectionAfterStepping [
	| adapter segments highlightSegment pcRangeForContext |
	
	dbg := self debuggerOn: session.
	adapter := SpMorphicCodeAdapter new.
	adapter adapt: dbg code.	
	dbg code adapter: adapter.
	dbg code adapter buildWidget.	
	dbg
		stepInto;
		stepInto.
	
	pcRangeForContext := (session pcRangeForContext: dbg currentContext).
	segments := dbg code adapter widget segments.
	self assert: segments size equals: 1.
	highlightSegment := segments first.	
	
	self
		assert:  (highlightSegment firstIndex to: highlightSegment lastIndex)
		equals: (pcRangeForContext first to: pcRangeForContext last + 1)
	"The pc range is highlighted with an additionnal index to encompass the full text of the node (why?)"
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextChangedAfterStepIn [ 

	dbg := self debuggerOn: session.
	dbg buildContextMenus.	
	
	dbg stepInto. "We enter the block context"
	self assert: dbg inspector inspectedObject context identicalTo: session shortStack first.
	
	dbg stepInto. "We step into the first message"
	self assert: dbg inspector inspectedObject context identicalTo:session shortStack first.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextChangedAfterStepOverAndReturn [
	| currentContext |
	dbg := self debuggerOn: session.	
		
	dbg stepInto; stepInto. "getting into Number>>squared"
	currentContext := dbg inspector inspectedObject context.
	dbg stepOver; stepOver.  "stepping over ^self * self (i.e. returning)"
	self
		deny: dbg inspector inspectedObject context
		equals: currentContext
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextTempVarList [
	| contextItems inspectorTable |
	
	dbg := self debuggerOn: session.
	inspectorTable := dbg inspector getRawInspectorPresenterOrNil attributeTable.
	
	5 timesRepeat: [ dbg stepInto  ].	
	contextItems := inspectorTable roots.
	self assert: contextItems size equals: 8. 	
		
	"First node is self"
	self assert: (contextItems at: 1) class equals: StInspectorSelfNode.	
	
	"Next nodes are temps"
	self assert: (contextItems at: 2) tempVariable isTempVariable.
	self assert: (contextItems at: 3) tempVariable isTempVariable.
	self assert: (contextItems at: 4) tempVariable isTempVariable.
	self assert: (contextItems at: 5) tempVariable isTempVariable.
	
	"receiver"	
	self assert: (contextItems at: 6) rawValue identicalTo: session shortStack first receiver session.
	
	"stackTop"
	self assert: (contextItems at: 7) rawValue equals: 1.
	
	"thisContext"
	self assert: contextItems last rawValue identicalTo: dbg currentContext
]

{ #category : 'tests' }
StDebuggerTest >> testContextTempVarListUpdatesAfterRestartingContext [

	| contextItems inspectorTable newContextItems |
	dbg := self debuggerOn: session.
	inspectorTable := dbg inspector getRawInspectorPresenterOrNil
		                  attributeTable.
		
	contextItems := inspectorTable roots copy.
	self assert: contextItems size equals: 8.

	"We enter the inlined block (node `i + 1`)"
	4 timesRepeat: [ dbg stepOver ].

	self assert: inspectorTable roots size equals: 9.

	"We restart the context"
	dbg restartCurrentContext.
	
	newContextItems := inspectorTable roots.

	self assert: newContextItems size equals: 8.
	1 to: 8 do: [ :i |
		self
			assert: (newContextItems at: i)
			identicalTo: (contextItems at: i) ]
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextTempVarListUpdatesTempsWhenEnteringOrLeavingInlinedBlocks [

	| contextItems inspectorTable newContextItems |
	dbg := self debuggerOn: session.
	inspectorTable := dbg inspector getRawInspectorPresenterOrNil
		                  attributeTable.

	"We stop on the node `i = 1` node"
	3 timesRepeat: [ dbg stepOver ].

	contextItems := inspectorTable roots copy.
	self assert: contextItems size equals: 8.

	"We enter inlined block"
	dbg stepOver.

	newContextItems := inspectorTable roots.

	self assert: newContextItems size equals: 9.

	1 to: 8 do: [ :i |
		self
			assert: (newContextItems at: i)
			identicalTo: (contextItems at: i) ].

	self assert: (newContextItems at: 9) tempVariable isTempVariable.
	self assert: (newContextItems at: 9) tempVariable name equals: 'j'.

	"We leave inlined block"
	2 timesRepeat: [ dbg stepOver ].

	self assert: newContextItems size equals: 8.
	1 to: 8 do: [ :i |
		self
			assert: (newContextItems at: i)
			identicalTo: (contextItems at: i) ]
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextTempVarListUpdatesTempsWhenEnteringOrLeavingInlinedBlocksWithRunTo [

	| contextItems inspectorTable newContextItems sourceCode targetCode beginIndex |
	dbg := self debuggerOn:
		       StTestDebuggerProvider new sessionWithInlinedLoop.
	inspectorTable := dbg inspector getRawInspectorPresenterOrNil
		                  attributeTable.

	"We stop on the node `b := 0` node"
	4 timesRepeat: [ dbg stepOver ].

	contextItems := inspectorTable roots copy.
	sourceCode := dbg context compiledCode sourceCode.

	"We enter inlined block"
	targetCode := 'nbMonth := nbMonth + 1'.
	beginIndex := sourceCode indexOfSubCollection: targetCode.
	dbg code selectionInterval:
		(Interval from: beginIndex to: beginIndex + targetCode size).
	dbg runToSelection.

	newContextItems := inspectorTable roots.

	self assert: newContextItems size equals: contextItems size + 1.

	1 to: contextItems size do: [ :i |
		self
			assert: (newContextItems at: i)
			identicalTo: (contextItems at: i) ].

	self assert:
		(newContextItems at: contextItems size + 1) tempVariable
			isTempVariable.
	self
		assert:
		(newContextItems at: contextItems size + 1) tempVariable name
		equals: 'list'.

	"We leave inlined block"
	targetCode := 'a := b * 42'.
	beginIndex := sourceCode indexOfSubCollection: targetCode.
	dbg code selectionInterval:
		(Interval from: beginIndex to: beginIndex + targetCode size).
	dbg runToSelection.

	self assert: newContextItems size equals: contextItems size.
	1 to: contextItems size do: [ :i |
		self
			assert: (newContextItems at: i)
			identicalTo: (contextItems at: i) ]
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testContextUnchangedAfterStepOver [
	| currentContext |
	
	dbg := self debuggerOn: session.	
	
	dbg stepInto; stepInto. "getting into Number>>squared"
	currentContext := dbg inspector inspectedObject.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	dbg stepOver. 
	self assert: dbg inspector inspectedObject identicalTo:  currentContext
]

{ #category : 'tests - actions' }
StDebuggerTest >> testCopyStackToClipboard [
	debugger := self debuggerOn: session.
	debugger copyStackToClipboard.
	self
		assert: Clipboard clipboardText string
		equals: (String streamContents: [ :s | 
				 session interruptedContext shortDebugStackOn: s ])
]

{ #category : 'tests' }
StDebuggerTest >> testCreateMissingMethodWithUnfilteredStackUpdatesCodePane [

	| dnuMessage method pcRangeForContext segments highlightSegment adapter |
	StDebuggerActionModel shouldFilterStack: false.
	debugger := StTestDebuggerProvider new debuggerWithDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.
	adapter := SpMorphicCodeAdapter new.
	adapter adapt: debugger code.
	debugger code adapter: adapter.
	debugger code adapter buildWidget.
	self assert:
		debugger debuggerActionModel isInterruptedContextDoesNotUnderstand.
	self
		assert: debugger interruptedContext receiver class
		identicalTo: StTestDebuggerProvider.
	dnuMessage := debugger debuggerActionModel contextPredicate exception
		              message.

	self assert: dnuMessage selector identicalTo: #foobar.

	"stack is unfiltered. So the text shown should be the code from the DNU"
	self assert: (debugger code text beginsWith: 'doesNotUnderstand:').

	"we create the missing method #foobar"
	debugger implementMissingMethod.

	method := StTestDebuggerProvider methodDictionary at: #foobar.

	"code must have been updated with the new method"
	self
		assert: debugger interruptedContext compiledCode
		identicalTo: method.
	self assert: debugger code text equals: method sourceCode.

	session := debugger session.
	pcRangeForContext := session pcRangeForContext:
		                     debugger currentContext.
	segments := debugger code adapter widget segments.
	self assert: segments size equals: 1.
	highlightSegment := segments first.

	self
		assert: (highlightSegment firstIndex to: highlightSegment lastIndex)
		equals: (pcRangeForContext first to: pcRangeForContext last + 1)
]

{ #category : 'tests - initialization' }
StDebuggerTest >> testDebuggerActionModel [
	"Checking that when initializing a debugger its action model is correctly set up.
	We cannot check that by calling the accessor because it is a lazy accessor. 
	We're using slot reflection instead."

	| slot debuggerActionModel |
	slot := StDebugger slotNamed: #debuggerActionModel.
	debugger := self debuggerOn: session.
	debuggerActionModel := slot read: debugger.

	self assert: debuggerActionModel isNotNil
]

{ #category : 'tests - initialization' }
StDebuggerTest >> testDebuggerApplication [
	self
		assert: (self debuggerOn: session) application
		identicalTo: StDebugger currentApplication
]

{ #category : 'tests - session' }
StDebuggerTest >> testDebuggerDoesNotLogStackToFileSetting [

	| logFileRef debuggingStackToFile |
	
	logFileRef := Smalltalk logFileName asFileReference.
	logFileRef ensureDelete.
	self deny: logFileRef exists.
	debuggingStackToFile := session class logDebuggerStackToFile.	
	[ 
		debugger := StTestDebuggerProvider new debuggerWithDNUContext. 
		session := debugger session.
		session class logDebuggerStackToFile: false.
		debugger
			application: debugger class currentApplication;
			initialize;
			open.

		self 
			assert: logFileRef exists not
			description: 'It tests that when the log debugger stack to file setting is false, a Pharo log file is not created when requesting a debugger' ]
	ensure: [ session class logDebuggerStackToFile: debuggingStackToFile ]
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testDiscardCodeChangesFor [
	| firstContext lastContext |
	
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	firstContext := dbg stackTable items first.	
	lastContext := dbg stackTable items last.		
	dbg code type: 'a'.
	dbg code update.
	dbg stackTable selectItem: lastContext.
	
	self assert: (dbg unsavedCodeChangesFor: firstContext) equals: 'a'.
	dbg stackTable selectItem: firstContext.
	
	dbg discardCodeChangesFor: firstContext.	
	self should: [ (dbg unsavedCodeChangesFor: firstContext) ] raise: KeyNotFound.
	self assert: dbg code text equals: firstContext sourceCode
	
	
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testDynamicVariableEvaluation [
	|activeProcess debuggedProcess|
	self skipOnPharoCITestingEnvironment.
	debugger := StTestDebuggerProvider new
		            debuggerWithDynamicVariableSuspendedContext.
	debugger initializeCode.
	activeProcess := Processor activeProcess.
	debuggedProcess := debugger debuggerActionModel interruptedProcess.
	
	"The active process and the debugged process are different"
	self
		deny: activeProcess
		identicalTo: debuggedProcess.
	self deny: debuggedProcess isActive.
	self assert: activeProcess isActive.
		
	"The debugged process holds the dynamic variable value"
	self assert: (debuggedProcess psValueAt: TestDynamicVariable soleInstance index) equals: 42.
		
	"The standard code presenters evaluates code from the active process"	
	self
		assert: (SpCodePresenter basicNew
				 evaluate: 'TestDynamicVariable value'
				 onCompileError: [  ]
				 onError: [ :e |  ])
		equals: nil.
	"The debugger code presenters evaluates code from the debugged process"
	self
		assert: (debugger code
				 evaluate: 'TestDynamicVariable value'
				 onCompileError: [  ]
				 onError: [ :e |  ])
		equals: 42
]

{ #category : 'tests' }
StDebuggerTest >> testExceptionProvidesSameExceptionAsTheActionModelOne [

	debugger := self debuggerOn: session.
	self
		assert: debugger exception
		identicalTo: debugger debuggerActionModel exception
]

{ #category : 'tests' }
StDebuggerTest >> testGenerateAndProceed [

	| baseSourceCode expectedSourceCode adapter |
	self skip:
		'Does not work, I do not know why it looks like my test is executed several times with the same debugger'.
	baseSourceCode := 'methodThatGeneratesCode

	| asserter |
	asserter := TestAsserter new.
	
	asserter see: 42 + 66 + 3'.

	expectedSourceCode := 'methodThatGeneratesCode

	| asserter |
	asserter := TestAsserter new.
	
	asserter see: 42 + 66 + 3 equals: 111'.

	debugger := StTestDebuggerProvider new
		            debuggerWithGeneratingCodeContext
		            application: self debuggerClass currentApplication;
		            initialize;
		            yourself.
	"just things necessary to use debugger's code presenter, which we need in this test"
	adapter := SpMorphicCodeAdapter new.
	adapter adapt: debugger code.
	debugger code adapter: adapter.
	debugger code adapter buildWidget.

	self assert: debugger canGenerateAndProceed.
	self assert: debugger exception isGeneratingCode.
	self
		assert: debugger interruptedContext sender sourceCode
		equals: baseSourceCode.

	oldMethodToSourceDictionary
		at: debugger interruptedContext sender method
		put: baseSourceCode.

	debugger saveGeneratedCodeAndProceed
	"self assert: debugger interruptedContext isNil"
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testInitialCodeSelectionAfterStepping [
	| adapter segments highlightSegment pcRangeForContext |
	
	dbg := self debuggerOn: session.
	adapter := SpMorphicCodeAdapter new.
	adapter adapt: dbg code.	
	dbg code adapter: adapter.
	dbg code adapter buildWidget.
	dbg stackTable selectItem: dbg stackTable items first.		
	
	pcRangeForContext := (session pcRangeForContext: dbg currentContext).
	segments := dbg code adapter widget segments.
	self assert: segments size equals: 1.
	highlightSegment := segments first.	
	
	self
		assert:  (highlightSegment firstIndex to: highlightSegment lastIndex)
		equals: (pcRangeForContext first to: pcRangeForContext last + 1)
	"The pc range is highlighted with an additionnal index to encompass the full text of the node (why?)"
]

{ #category : 'tests' }
StDebuggerTest >> testInterruptedContextProvidesSameContextAsTheActionModelOne [

	debugger := self debuggerOn: session.
	self
		assert: debugger interruptedContext
		identicalTo: debugger debuggerActionModel interruptedContext
]

{ #category : 'tests' }
StDebuggerTest >> testInterruptedProcessProvidesSameProcessAsTheActionModelOne [

	debugger := self debuggerOn: session.
	self
		assert: debugger interruptedProcess
		identicalTo: debugger debuggerActionModel interruptedProcess
]

{ #category : 'tests' }
StDebuggerTest >> testIsInSelectedContextClass [

	| stackTable context process |
	context := thisContext.
	process := Process forContext: context priority: Processor userInterruptPriority.
	session := DebugSession named: 'test session stDebuggerTestTestIsInSelectedContextClass' on: process startedAt: context.
	session exception: OupsNullException new.

	debugger := self debuggerOn: session.
	stackTable := debugger stackTable.

	stackTable selectItem: (stackTable items at: 2).
	"Let's make sure we select the method we want in case SUnit changes in the future and that our tests will be on the right methods."
	self assert: stackTable selectedItem method selector equals: #performTest.
	self assert: (stackTable items at: 7) method selector equals: #runCase.

	self assert: (debugger isInSelectedContextClass: (stackTable items at: 7))
]

{ #category : 'tests' }
StDebuggerTest >> testIsInSelectedContextPackage [

	| stackTable context process |
	context := thisContext.
	process := Process forContext: context priority: Processor userInterruptPriority.
	session := DebugSession named: 'test session stDebuggerTesttestIsInSelectedContextPackage' on: process startedAt: context.
	session exception: OupsNullException new.

	debugger := self debuggerOn: session.
	stackTable := debugger stackTable.

	stackTable selectItem: (stackTable items at: 2).
	"Let's make sure we select the method we want in case SUnit changes in the future and that our tests will be on the right methods."
	self assert: stackTable selectedItem method selector equals: #performTest.
	self assert: (stackTable items at: 12) method selector equals: #runTestCaseUnderWatchdog:.

	self assert: (debugger isInSelectedContextPackage: (stackTable items at: 12))
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testNewDebuggerContext [
	| debuggerContext |
	
	debugger := (self debuggerOn: session).
	debuggerContext := debugger newDebuggerContext.
	self assert: debuggerContext class identicalTo: debugger class debuggerContextClass.
	self assert: debuggerContext exception equals: session exception
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testNewDebuggerContextFor [
	| debuggerContext ctx |
	
	debugger := (self debuggerOn: session).
	ctx := [  ] asContext.
	debuggerContext := debugger newDebuggerContextFor: ctx.
	self assert: debuggerContext class identicalTo: debugger class debuggerContextClass.
	self assert: debuggerContext exception equals: session exception.
	self assert: debuggerContext context identicalTo: ctx
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testOpenDebuggerWithLastKnownExtent [

	self settings preserveWindowPositionAndExtent: true.
	dbg := (self debuggerOn: session) open.
	"Check window is opened with the saved extent"
	self 
		assert: self settings lastKnownExtent 
		equals: dbg window window extent.

	dbg close.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testOpenDebuggerWithLastKnownPosition [

	self settings preserveWindowPositionAndExtent: true.
	dbg := (self debuggerOn: session) open.
	"Check window is opened with the saved position"
	self 
		assert: self settings lastKnownPosition
		equals: dbg window window position.

	dbg close.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testPreserveLastKnownExtentIsFalse [

	| newDbgExtent |

	self settings preserveWindowPositionAndExtent: false.
	dbg := (self debuggerOn: session) open.

	newDbgExtent := 100 @ 200.
	"Programmatically change the extent of debugger window"
	dbg window window extent: newDbgExtent.
	"New extent is saved when the window is closed"
	dbg close.

	self 
		deny: self settings lastKnownExtent 
		equals: newDbgExtent.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testPreserveLastKnownExtentIsTrue [

	| newDbgExtent |

	dbg := (self debuggerOn: session) open.

	newDbgExtent := 100 @ 200.
	"Programmatically change the extent of debugger window"
	dbg window window extent: newDbgExtent.
	"New extent is saved when the window is closed"
	dbg close.

	self 
		assert: self settings lastKnownExtent 
		equals: newDbgExtent.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testPreserveLastKnownPositionIsFalse [

	| newDbgPosition |

	self settings preserveWindowPositionAndExtent: false.
	dbg := (self debuggerOn: session) open.

	newDbgPosition := 100 @ 200.
	"Programmatically change the extent of debugger window"
	dbg window window position: newDbgPosition.
	"New extent is saved when the window is closed"
	dbg close.

	self 
		deny: self settings lastKnownExtent 
		equals: newDbgPosition
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testPreserveLastKnownPositionIsTrue [

	| newDbgPosition |

	dbg := (self debuggerOn: session) open.

	newDbgPosition := 500 @ 100.
	"Programmatically change the position of debugger window"
	dbg window window position: newDbgPosition.
	"New position is saved when the window is closed"
	dbg close.

	self
		assert: newDbgPosition 
		equals: self settings lastKnownPosition.
		

]

{ #category : 'tests - stack table' }
StDebuggerTest >> testPrintReceiverClassInContext [
	|ctx stream |
	ctx := Context sender: nil receiver: Set new method: (Collection>>#add:) arguments: Array new. 
	stream := WriteStream on: String new.
	StContextPrinter printReceiverClassInContext: ctx on: stream.
	self assert: stream contents equals: 'Set (Collection)'.
	
	ctx := Context sender: nil receiver: Set new method: (Set>>#add:) arguments: Array new. 
	stream := WriteStream on: String new.
	StContextPrinter printReceiverClassInContext: ctx on: stream.
	self assert: stream contents equals: 'Set'.
]

{ #category : 'tests - receiver inspector' }
StDebuggerTest >> testReceiverChangedAfterStepIn [ 

	dbg := self debuggerOn: session.
	
	dbg stepInto. "We enter the block context"
	self assert: dbg inspector inspectedObject context receiver identicalTo: session shortStack first receiver.
	
	dbg stepInto. "We step into the first message"
	self assert: dbg inspector inspectedObject context receiver identicalTo: session shortStack first receiver
]

{ #category : 'tests - receiver inspector' }
StDebuggerTest >> testReceiverChangedAfterStepOverAndReturn [
	| currentReceiver |
	
	dbg := self debuggerOn: session.	
	
	dbg stepInto; stepInto. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject.
	dbg stepOver; stepOver. "stepping over ^self * self (i.e. returning)"
	self
		deny: dbg inspector inspectedObject
		equals: currentReceiver
]

{ #category : 'tests - receiver inspector' }
StDebuggerTest >> testReceiverList [
	| currentReceiver |
	dbg := self debuggerOn: session.	
	
	dbg stepInto; stepInto. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject context receiver.	
	self assert: currentReceiver equals: 1

]

{ #category : 'tests - receiver inspector' }
StDebuggerTest >> testReceiverUnchangedAfterStepOver [ 
	| currentReceiver |
	
	dbg := self debuggerOn: session.	
	
	dbg stepInto; stepInto. "getting into Number>>squared"
	currentReceiver := dbg inspector inspectedObject context receiver.
	"stepping over one time ^self * self (i.e. we are on the return node but still in the same context)"
	dbg stepOver. 
	self assert: dbg inspector inspectedObject context receiver identicalTo:  currentReceiver

]

{ #category : 'tests - code pane' }
StDebuggerTest >> testRecordUnsavedCodeChanges [
	| lastContext |
	
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	lastContext := dbg stackTable items last.		
	dbg code type: 'a'.
	dbg code update.
	
	self assert: dbg code text equals: 'a'.
	self deny: dbg selectedContext sourceCode equals: dbg code text.

	dbg stackTable selectItem: lastContext.
	self assert: dbg code text equals: lastContext sourceCode.
	self assert: (dbg unsavedCodeChangesFor: dbg stackTable items first) equals: 'a'
]

{ #category : 'tests - session' }
StDebuggerTest >> testRestartContext [
	| firstContext lastContext |
	
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	firstContext := dbg stackTable items first.	
	lastContext := dbg stackTable items last.
		
	"We select the last context and we change the code but we do not save.
	The unsaved code change is kept when we select another context (the first one)"	
	dbg stackTable selectItem: lastContext.	
	dbg code type: 'a'.
	dbg code update.	
	dbg stackTable selectItem: firstContext.	
	self assert: (dbg unsavedCodeChangesFor: lastContext) equals: 'a'.	
		
	"We select again the last context and restart it:
	- unsaved code changes are dropped
	- the restarted context is now the first context of the stack
	- the code is reset to the source of the restarted context"	
	dbg stackTable selectItem: lastContext.				
	dbg restartCurrentContext. 	
	self assertEmpty: dbg unsavedCodeChanges.
	self assert: dbg code text equals: lastContext sourceCode.
	self assert: dbg stackTable items first equals: lastContext
	
	

]

{ #category : 'tests - raw inspection' }
StDebuggerTest >> testRestoreReceiverRawInspectionSelection [
	self skip.
	self flag: #DBG_TEST
]

{ #category : 'tests - raw inspection' }
StDebuggerTest >> testRestoreReceiverRawInspectionSelectionAfterContextChange [

	self skip.
	self flag: #DBG_TEST
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testRestoreUnsavedCodeChanges [
	| firstContext lastContext |
	
	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
	firstContext := dbg stackTable items first.
	lastContext := dbg stackTable items last.
	
	self assert: dbg code text equals: firstContext sourceCode.
	dbg code type: 'a'.
	dbg update.
	
	dbg stackTable selectItem: lastContext.
	self assert: dbg code text equals: lastContext sourceCode.
	
	dbg stackTable selectItem: firstContext.
	self assert: dbg code text equals: 'a'
]

{ #category : 'tests - session' }
StDebuggerTest >> testReturnEnteredValue [
	self skip.
	self flag: #DBG_TEST
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testSaveCodeModification [
	| context newSource |
	
	dbg := StTestDebuggerProvider new debuggerWithObjectHalting.
	dbg
		application: dbg class currentApplication;
		initialize;
		buildContextMenus.
	context := dbg stackTable items first.
	newSource := 'haltingMethod ^1+1 squared'.	
	dbg code type: newSource.
	dbg code update.
	dbg unsavedCodeChanges at: 4 put: 2.
	
	dbg code triggerSubmitAction.	
	self assertEmpty: dbg unsavedCodeChanges.
	self assert: context sourceCode equals: newSource.
	self assert: dbg code text equals: context sourceCode
	
	

]

{ #category : 'tests - raw inspection' }
StDebuggerTest >> testSaveReceiverRawInspectionSelection [

	self skip.
	self flag: #DBG_TEST
]

{ #category : 'tests - raw inspection' }
StDebuggerTest >> testSaveReceiverRawInspectionSelectionAfterContextChange [

	self skip.
	self flag: #DBG_TEST
]

{ #category : 'tests - accepting faulty code' }
StDebuggerTest >> testSavingQuickMethodWhenSteppingIntoStackSizeBeforeIsTheSameAfter [

	self replaceMethodWithQuickMethodStepping.

	self assert: dbg session stack size equals: stackSizeBefore
]

{ #category : 'tests - accepting faulty code' }
StDebuggerTest >> testSavingQuickMethodWhenSteppingIntoStaysInQuickMethod [
	
	"We tell the parent that we wanted to step into"
	self replaceMethodWithQuickMethodStepping.
	
	self assert: dbg stackTable items first sourceCode equals: 'haltingMethod ^ 1'
]

{ #category : 'tests - stack table' }
StDebuggerTest >> testSelectLastStackElementWithMoreElements [
	| stackTable selectedItem |
	
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	
	dbg stepInto; stepInto.
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

{ #category : 'tests - stack table' }
StDebuggerTest >> testSelectLastStackElementWithoutMoreElements [
	| stackTable startingStackSize |
	
	dbg := self debuggerOn: session.
	stackTable := dbg stackTable.
	startingStackSize := stackTable items size.
	stackTable selectItem: stackTable items last.
	
	self assert: stackTable items size equals: startingStackSize
]

{ #category : 'tests' }
StDebuggerTest >> testSessionProvidesSameAsTheActionModelOne [

	debugger := self debuggerOn: session.
	self
		assert: debugger session
		identicalTo: debugger debuggerActionModel session
]

{ #category : 'tests' }
StDebuggerTest >> testSessionStackProvidesSameStackAsTheActionModelOne [

	debugger := self debuggerOn: session.
	self
		assertCollection: debugger stack
		equals: debugger debuggerActionModel stack
]

{ #category : 'tests - stack table' }
StDebuggerTest >> testStackTableAfterReturn [
	| stackTableItems stackSizeAfterStepIn |
	
	dbg := self debuggerOn: session.

	"we dive into a method"
	dbg stepInto; stepInto.
	stackSizeAfterStepIn := dbg stackTable items size.

	"we return from it"
	dbg stepOver; stepOver.
	stackTableItems := dbg stackTable items.
	self assert: dbg stackTable selection selectedIndex equals: 1.
	self assert: dbg stackTable selection selectedItem identicalTo: session shortStack first.
	self assert: stackTableItems size equals: stackSizeAfterStepIn - 1.
	self assert: stackTableItems equals: session shortStack
]

{ #category : 'tests - stack table' }
StDebuggerTest >> testStackTableAfterStepIn [
	| stackTableItems startingStackSize |
	
	dbg := self debuggerOn: session.
	startingStackSize := dbg stackTable items size.
	dbg stepInto; stepInto.
	stackTableItems := dbg stackTable items.
	self assert: dbg stackTable selection selectedIndex equals: 1.
	self
		assert: dbg stackTable selection selectedItem identicalTo: session shortStack first.
	self assert: stackTableItems size equals: startingStackSize + 1.
	self assert: stackTableItems equals: session shortStack
]

{ #category : 'tests - stack table' }
StDebuggerTest >> testStackTableInitialization [
	self assert: self debugger stackTable isNil
]

{ #category : 'tests - stack table' }
StDebuggerTest >> testStackTableSelectionChanged [

	dbg := self debuggerOn: session.
	dbg stepInto; stepInto.
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

{ #category : 'tests - stack table' }
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

{ #category : 'tests - toolbar' }
StDebuggerTest >> testToolbarDisplayMode [
	debugger := self debuggerOn: session.
	self
		assert: debugger toolbar displayMode
		equals: debugger application toolbarDisplayMode
]

{ #category : 'tests - toolbar' }
StDebuggerTest >> testToolbarInDNUContext [
	|commands|
	session clear.
	session := StTestDebuggerProvider new sessionWithDNUAfterStep.

	self debuggerOn: session.
	"debugger buildContextMenus.	"
	commands := self executionControlCommandFrom: debugger.	

	"We're not in a DNU, buttons are enabled"
	commands do: [ :c| self assert: c isEnabled].
	
	"We step into the DNU, buttons should be disabled"
	debugger stepInto.
	debugger stepOver.

	commands do: [ :c| self deny: c isEnabled].

	"We define the missing method from outside the debugger, buttons should automatically be enabled"
	StTestDebuggerProvider compile: 'foobar ^self'.
	commands do: [ :c| self assert: c isEnabled].
	
	
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testUnsavedCodeChanges [

	dbg := self debuggerOn: session.
	self assert: dbg unsavedCodeChanges class identicalTo: IdentityDictionary.
	self assertEmpty: dbg unsavedCodeChanges 
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testUnsavedCodeChangesFor [
	| ctx codeChanges |
	
	dbg := self debuggerOn: session.
	self should: [dbg unsavedCodeChangesFor: dbg currentContext] raise: KeyNotFound.
	dbg unsavedCodeChanges at: (ctx := Object new) put: (codeChanges := Object new).
	self assert: (dbg unsavedCodeChangesFor: ctx) identicalTo: codeChanges
	

]

{ #category : 'tests' }
StDebuggerTest >> testUpdateExtensionSubscription [

	| announcementSubscriptions oldAnnouncementSubscriptions |
	oldAnnouncementSubscriptions := self
		                                subscriptionsForStDebuggerExtensionActivationToggle.

	self debugger session: session.
	self initializedDebugger.
	announcementSubscriptions := self
		                             subscriptionsForStDebuggerExtensionActivationToggle.
	self
		assert: announcementSubscriptions size
		equals: oldAnnouncementSubscriptions size + 1.
	self
		assertCollection: announcementSubscriptions
		includesAll: oldAnnouncementSubscriptions.
	self assert: (announcementSubscriptions detect: [ :s |
			 s subscriber == dbg and: [
				 s action selector == #updateExtensionsFromAnnouncement: ] ])
			isNotNil
]

{ #category : 'tests - receiver inspector' }
StDebuggerTest >> testUpdateLayoutForContextsIfAssertionFailure [

	| assertionFailure currentLayout expectedLayout |
	debugger := StTestDebuggerProvider new
		            debuggerWithFailingAssertionContext.
	session := debugger session.
	debugger application: StDebugger currentApplication.
	debugger initialize.
	debugger updateInspectorFromContext: session interruptedContext.
	assertionFailure := debugger inspector assertionFailure.
	currentLayout := debugger inspector layout.
	expectedLayout := StDebuggerInspector new assertionFailureLayout.
	StDebuggerInspector maximizeAssertionSpec: false.
	self assert: currentLayout direction equals: expectedLayout direction.
	self
		assertCollection: currentLayout children first class
		equals: expectedLayout children first class.
	self
		assertCollection: currentLayout children first direction
		equals: expectedLayout children first direction.
	self
		assertCollection: currentLayout children second
		equals: expectedLayout children second.
	self
		assert: currentLayout positionOfSlider
		equals: expectedLayout positionOfSlider.
	self
		assert: currentLayout children size
		equals: expectedLayout children size.
	self
		assert: assertionFailure actualObject
		equals:
		((session interruptedContext tempNamed: #aStringOrBlock) at: 2).
	self
		assert: assertionFailure expectedObject
		equals:
		((session interruptedContext tempNamed: #aStringOrBlock) at: 1)
]

{ #category : 'tests - code pane' }
StDebuggerTest >> testUpdateSourceCodeFor [

	dbg := self debuggerOn: session.
	dbg unsavedCodeChanges at: 4 put: '2'.
	
	dbg updateSourceCodeFor: 4.
	self assert: dbg code text equals: '2'.
	
	dbg updateSourceCodeFor: (self class>>#testUpdateSourceCodeFor).
	self assert: dbg code text equals: (self class>>#testUpdateSourceCodeFor) sourceCode.
]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testValueOfLastKnownExtentIsChangedWhenWindowIsClosed [

	| newDbgExtent |

	dbg := (self debuggerOn: session) open.

	newDbgExtent := 500 @ 100.
	"Programmatically change the position of debugger window"
	dbg window window extent: newDbgExtent.
	"New position is saved when the window is closed"
	dbg close.

	self 
		assert: self settings lastKnownExtent
		equals: newDbgExtent.

]

{ #category : 'tests - context inspector' }
StDebuggerTest >> testValueOfLastKnownPositionIsChangedWhenWindowIsClosed [

	| newDbgPosition |

	dbg := (self debuggerOn: session) open.

	newDbgPosition := 500 @ 100.
	"Programmatically change the position of debugger window"
	dbg window window position: newDbgPosition.
	"New position is saved when the window is closed"
	dbg close.

	self 
		assert: self settings lastKnownPosition 
		equals: newDbgPosition.
]
