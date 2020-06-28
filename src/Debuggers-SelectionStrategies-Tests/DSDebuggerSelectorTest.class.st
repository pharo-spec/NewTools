Class {
	#name : #DSDebuggerSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggers',
		'debuggerSelector'
	],
	#category : #'Debuggers-SelectionStrategies-Tests'
}

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> assertDebuggerOpened: aDebugger onException: anException inProcess: aProcess [
	| session process |
	session := aDebugger tag.
	self assert: session class equals: DebugSession.
	self assert: session exception identicalTo: anException.

	"The interrupted process is the one given to the API, 
	whatever this process is."
	process := session interruptedProcess.
	self assert: session interruptedProcess identicalTo: aProcess.
	self deny: process isTerminating.
	self deny: process isTerminated.
	self assert: process isSuspended
]

{ #category : #helper }
DSDebuggerSelectorTest >> session [
	| context process session |
	context := [ Set new ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := process
		newDebugSessionNamed: 'test session'
		startedAt: context.
	^ session
]

{ #category : #running }
DSDebuggerSelectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	debuggers := OrderedCollection
		withAll:
			{(DSDummyDebugger named: #A).
			(DSDummyDebugger named: #B).
			(DSDummyDebugger named: #C)}.
	debuggerSelector := DSDebuggerSelector with: debuggers copy
]

{ #category : #running }
DSDebuggerSelectorTest >> tearDown [
	debuggers
		do: [ :dbg | 
			(dbg tag isKindOf: DebugSession)
				ifTrue: [ dbg tag terminate ] ].
	super tearDown
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testAvailableDebuggers [
	|availableDebuggerClasses sortedDebuggerClasses|
	self fail.
	availableDebuggerClasses := OldDebuggerSelector availableDebuggers collect:[:assoc| assoc key].
	sortedDebuggerClasses := OldDebuggerSelector sortedDebuggersByRank collect:[:assoc| assoc value].  
	self assertCollection: availableDebuggerClasses equals: sortedDebuggerClasses 
]

{ #category : #'tests - debugging API' }
DSDebuggerSelectorTest >> testDebugExceptionInProcessFrom [
	| exception process |
	[ DSDummyDebugger new zeroDivide ]
		on: Exception
		do: [ :e | 
			exception := e.
			DummyDebuggerSelector
				debugException: exception
				inProcess: (process := [  ] newProcess)
				from: DSDummyDebugger new ].
	self
		assertDebuggerOpened: debuggers second
		onException: exception
		inProcess: process
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testDebugExceptionInProcessFromWith [
	| process exception dummyUIManager |
	
	self flag: 'Process are not the same, which is OK from the API point of view, but not accurate from the execution point of view'.
	[ DSDummyDebugger new zeroDivide ]
		on: Exception
		do: [ :e | 
			exception := e.
			DebuggerSelector
				debugException: exception
				inProcess: (process := [ ] newProcess)
				from: (dummyUIManager := DSDummyDebugger new)
				with: debuggerSelector ].

	"With this test, we ensure that calling the API opens a debugger on a debug session,
	that holds the exception, its signaler context and the interrupted process.
	We check the second debugger because it is the one that is selected (first always fails)."
	self assertDebuggerOpened: debuggers second onException: exception inProcess: process.
	
	""
	self assert: dummyUIManager deferred
	
]

{ #category : #'tests - debugging API' }
DSDebuggerSelectorTest >> testDebugMethodInProcessFromContextLabeled [
	| dbg session process suspendedContext |
	process := [ DSDummyDebugger new methodToDebug ] newProcess.
	suspendedContext := process suspendedContext.
	DummyDebuggerSelector
		debugMethod: DSDummyDebugger >> #methodToDebug
		inProcess: process
		fromContext: suspendedContext
		labeled: 'debug it'.
	dbg := debuggers second.
	session := dbg tag.
	self
		assertDebuggerOpened: dbg
		onException: session exception
		inProcess: process.
	self
		assert: session interruptedContext method
		identicalTo: DSDummyDebugger >> #methodToDebug.
	self
		assert: session exception class
		equals: DebuggerSelectorNullException.
		
	"Debugger Selector must have put us right at the entry of the method.
	If we step over, we should be on the first ast node of the method"
	session stepOver.
	self
		assert: ((DSDummyDebugger >> #methodToDebug) sourceNodeForPC: session interruptedContext pc)
		identicalTo: (DSDummyDebugger >> #methodToDebug) ast statements first.
]

{ #category : #'tests - debugging API' }
DSDebuggerSelectorTest >> testDebugProcessFromContextLabeled [
	| context process session interruptedProcess exception |	
	context := [  ] asContext.
	process := [  ] newProcess.
	"we use the dummy debugger selector to control the debuggers list and the ui manager.
	we do not actually want to raise a real warning but just to ensure
	the API gets the system to the opening of a debugger with the exception."
	DummyDebuggerSelector
		debugProcess: process
		fromContext: context
		labeled: #tag.
	session := debuggers second tag.
	interruptedProcess := session interruptedProcess.
	exception := session exception.
	self assert: session class equals: DebugSession.
	self assert: interruptedProcess identicalTo: process.
	self assert: interruptedProcess isSuspended.
	self assert: session interruptedContext identicalTo: context.
	self assert: exception class equals: DebuggerSelectorNullException.
	self assert: exception signalerContext identicalTo: context.
	self assert: exception messageText equals: #tag.
	self assert: DummyDebuggerSelector uiManager deferred 
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testDebugSessionClass [
	self assert: DebuggerSelector debugSessionClass equals: DebugSession
]

{ #category : #'tests - debugging API' }
DSDebuggerSelectorTest >> testDebuggerWarningFrom [
	| dbg |
	dbg := DSDummyDebugger new.
	DebuggerSelector debuggerWarning: #tag from: dbg.
	self assert: dbg tag equals: #tag
]

{ #category : #'tests - debugging API' }
DSDebuggerSelectorTest >> testDebuggerWarningInProcessFrom [
	|e p|
	[ Warning signal: #tag ]
		on: Warning
		do: [ :w | 
			e := w.
			"we use the dummy debugger selector to control the debuggers list.
			we do not actually want to raise a real warning but just to ensure
			the API gets the system to the opening of a debugger with the exception."
			DummyDebuggerSelector
				debuggerWarning: w
				inProcess: (p := [  ] newProcess)
				from: DSDummyDebugger new ].
	self assertDebuggerOpened: debuggers second onException: e inProcess: p
]

{ #category : #tests }
DSDebuggerSelectorTest >> testDebuggers [
	self
		assertCollection: debuggerSelector debuggers asOrderedCollection
		equals: debuggers
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testDebuggersWithRanks [
	|assocs systemDebuggers|
	self fail.
	assocs := OldDebuggerSelector debuggersWithRanks.
	systemDebuggers := Smalltalk tools debuggers.
	self assert: assocs size equals: systemDebuggers size.
	self assertCollection: assocs equals: systemDebuggers

]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testFindDebuggerForDebuggerFailure [
	| process semaphore exception session |
	semaphore := Semaphore new.
	process := [ [ 1 / 0 ]
		on: Error
		do: [ :err | exception := DebuggerFailure of: debuggers second on: err ] ]
		newProcess.
	[[ process resume ]
		ensure: [ semaphore signal ]] fork.
	semaphore wait.
	
	session := debuggerSelector
		newSessionFromException: exception
		forProcess: process.
		
	self
		assert: (debuggerSelector findDebuggerForSession: session)
		identicalTo: debuggers third
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testFirstUsableDebuggerForSession [
	
	debuggerSelector debuggers first beUnusable.
	debuggerSelector debuggers second beUnusable.

	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: debuggers third
	
	
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testLabeledDebuggers [
	| dbgs labeledDebuggers |
	self fail.
	dbgs := {(999 -> 'main dbg').
	(80 -> 'a dbg').
	(5 -> 'another dbg')}.
	labeledDebuggers := OldDebuggerSelector labeledDebuggers: dbgs.
	self assert: labeledDebuggers first key equals: 'main dbg'.
	self assert: labeledDebuggers first value equals: 'Main'.
	self assert: labeledDebuggers second key equals: 'a dbg'.
	self assert: labeledDebuggers second value equals: '80'.
	self assert: labeledDebuggers third key equals: 'another dbg'.
	self assert: labeledDebuggers third value equals: '5'
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testNewDebuggerSelector [
	| dbgsel |
	dbgsel := DebuggerSelector newDebuggerSelector.
	self assert: dbgsel class equals: DebuggerSelector.
	self
		assertCollection: dbgsel availableDebuggers
		equals: DebuggerSelector availableDebuggers
]

{ #category : #'tests - sessions' }
DSDebuggerSelectorTest >> testNewSessionFromExceptionForProcess [

	|exception process session|
	exception := DebuggerSelectorNullException new signalIn: [] asContext; yourself.
	process := [  ] newProcess.
	session := debuggerSelector newSessionFromException: exception forProcess: process.
	self assert: session interruptedProcess identicalTo: process.
	self assert: session exception identicalTo: exception.
	self assert: session interruptedContext identicalTo: exception signalerContext
]

{ #category : #tests }
DSDebuggerSelectorTest >> testNextDebugger [
	debuggers
		do: [ :dbg | self assert: debuggerSelector nextDebugger identicalTo: dbg ]
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testNextDebuggerForSession [
	
	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: debuggers first.
	
	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: debuggers second.
		
	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: debuggers last.
		
	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: Transcripter.
		
	
	
]

{ #category : #tests }
DSDebuggerSelectorTest >> testNoNextDebugger [
	debuggerSelector debuggers: #().
	self assert: debuggerSelector nextDebugger identicalTo: Transcripter
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testNullExceptionForNamed [
	|ctx e|
	ctx := Context newForMethod: (DSDummyDebugger>>#tag).
	ctx receiver: self.
	e := DebuggerSelector nullExceptionFor: ctx named: #tag.
	self assert: e receiver identicalTo: self.
	self assert: e signalerContext identicalTo: ctx.
	self assert: e messageText equals: #tag
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testOpenOn [
	"Basically openOn: finds a debugger and calls tryOpen:on:.
	So the first usable debugger (second in the list, see setUp)
	should work"
	| session |
	session := self session.
	debuggerSelector openOn: session.
	self assert: debuggers second tag identicalTo: session
]

{ #category : #'tests - sessions' }
DSDebuggerSelectorTest >> testPerformPreDebugActionsOn [
	| tag |
	"Default debug action is an empty block with 1 parameter"
	debuggerSelector performPreDebugActionsOn: #tag.

	"Custom debug action should execute the give block"
	debuggerSelector preDebugAction: [ :session | tag := session ].
	debuggerSelector performPreDebugActionsOn: #tag.
	self assert: tag equals: #tag
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testPreDebugActionForDebugItMethod [
	| session process suspendedContext |
	process := [ DSDummyDebugger new methodToDebug ] newProcess.
	suspendedContext := process suspendedContext.
	session := debuggerSelector
		newSessionFromException: (DebuggerSelector nullExceptionFor: suspendedContext named: #tag)
		forProcess: process.
	(DebuggerSelector
		preDebugActionForDebugItMethod: DSDummyDebugger >> #methodToDebug)
		value: session.

	"Debugger Selector must have put us right at the entry of the method.
	If we step over, we should be on the first ast node of the method"
	self
		assert: session interruptedContext method
		identicalTo: DSDummyDebugger >> #methodToDebug.
	session stepOver.
	self
		assert:
			(DSDummyDebugger >> #methodToDebug
				sourceNodeForPC: session interruptedContext pc)
		identicalTo: (DSDummyDebugger >> #methodToDebug) ast statements first
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testRegisteredDebuggersWithRanks [
	self fail
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testResumeException [
	| res |
	[ res := DummyExceptionToResume signal ]
		on: DummyExceptionToResume
		do: [ :e | DebuggerSelector resumeException: e ].
	self assert: res equals: #tag
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testSignalDebuggerError [
	"The dummy debugger selector uses a debug session object that does not actually signal a debugger error."

	| exception signalerBlock |
	exception := DebuggerSelectorNullException
		fromSignallerContext: [  ] asContext.
	signalerBlock := [ DummyDebuggerSelector
		signalDebuggerError: exception ].
	
	self should: signalerBlock raise: DebuggerFailure.
	signalerBlock
		on: DebuggerFailure
		do: [ :e | 
			self
				assert: e failedDebugger name
				equals: DebuggerSelector signalDebuggerErrorMessage.
			self assert: e innerException identicalTo: exception ]
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testSortedDebuggersByRank [
	| assocs systemDebuggers sortedRanks expectedRanks |
	self fail.
	assocs := OldDebuggerSelector sortedDebuggersByRank.
	systemDebuggers := Smalltalk tools debuggers.
	self
		assertCollection: (assocs collect: [ :assoc | assoc value ])
		includesAll: (systemDebuggers collect: [ :assoc | assoc key ]).
	sortedRanks := assocs collect: [ :assoc | assoc key ].
	expectedRanks := (systemDebuggers collect: [ :assoc | assoc value ]) asSortedCollection.
	self assert: sortedRanks equals: expectedRanks asOrderedCollection reversed
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testTryOpenOn [
	| debugger session |
	session := self session.

	"In case of error, it should raise a debugger failure."
	debugger := DummyUnusableDebugger new.
	self
		should: [ debuggerSelector tryOpen: debugger on: session ]
		raise: DebuggerFailure.
	[ debuggerSelector tryOpen: debugger on: session ]
		on: DebuggerFailure
		do: [ :dbgFailure | 
			self assert: dbgFailure signaler identicalTo: debugger.
			self assert: dbgFailure failedDebugger identicalTo: debugger.
			self deny: (dbgFailure isHandleableBy: debugger).
			self
				assert: dbgFailure innerException
				identicalTo: dbgFailure originException.
			self
				assert: dbgFailure innerException
				identicalTo: debugger tag.
			 ].

	"A bit simplistic: we just check that tryOpen:On: 
	sends debugSession: to the debugger with the session
	as argument."
	debugger := DSDummyDebugger new.
	debuggerSelector tryOpen: debugger on: session.
	self assert: debugger tag identicalTo: session
]

{ #category : #'tests - debuggers' }
DSDebuggerSelectorTest >> testWith [
	|trace|
	trace := Object new.
	self assert: (DebuggerSelector with: trace) availableDebuggers identicalTo: trace
]
