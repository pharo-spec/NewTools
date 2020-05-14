Class {
	#name : #DebuggerSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggerSelector',
		'eventListener',
		'debugSession',
		'testDebuggerClass',
		'debuggers'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #helper }
DebuggerSelectorTest >> session [
	| process |
	process := [  ] newProcess.
	^ debuggerSelector
		newSessionFromException:
			(DebuggerSelectorNullException
				fromSignallerContext: process suspendedContext)
		forProcess: process
]

{ #category : #running }
DebuggerSelectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	debuggers := OrderedCollection
		withAll:
			{(DummyUnusableDebugger named: #A).
			(DummyDebugger named: #B).
			(DummyDebugger named: #C)}.
	debuggerSelector := NewDebuggerSelector with: debuggers copy
]

{ #category : #running }
DebuggerSelectorTest >> tearDown [
	debuggers
		do: [ :dbg | 
			(dbg tag isKindOf: DebugSession)
				ifTrue: [ dbg tag terminate ] ].
	super tearDown
]

{ #category : #'tests - debuggers' }
DebuggerSelectorTest >> testAvailableDebuggers [
	|availableDebuggerClasses sortedDebuggerClasses|
	self fail.
	availableDebuggerClasses := DebuggerSelector availableDebuggers collect:[:assoc| assoc key].
	sortedDebuggerClasses := DebuggerSelector sortedDebuggersByRank collect:[:assoc| assoc value].  
	self assertCollection: availableDebuggerClasses equals: sortedDebuggerClasses 
]

{ #category : #'tests - debugging API' }
DebuggerSelectorTest >> testDebugExceptionInProcessFrom [
	self fail
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testDebugExceptionInProcessFromWith [
	| process exception context |
	context := [ DummyDebugger new zeroDivide ] asContext.
	process := Process
		forContext: context
		priority: Processor activePriority.
	self flag: 'Process are not the same, which is OK from the API point of view, but not accurate from the execution point of view'.
	[ DummyDebugger new zeroDivide ]
		on: Exception
		do: [ :e | 
			exception := e.
			context := exception signalerContext.
			context privRefresh.
			NewDebuggerSelector
				debugException: exception
				inProcess: process
				from: DummyDebugger new
				with: debuggerSelector ].

	"With this test, we ensure that calling the API opens a debugger on a debug session,
	that holds the exception, its signaler context and the interrupted process.
	We check the second debugger because it is the one that is selected (first always fails)."
	self assert: debuggers second tag class equals: DebugSession.
	self assert: debuggers second tag exception identicalTo: exception.
	
	"The interrupted process is the one given to the API, 
	whatever this process is."	
	self
		assert: debuggers second tag interruptedProcess
		identicalTo: process.
	self deny: process isTerminating.
	self deny: process isTerminated.
	self assert: process isSuspended
]

{ #category : #'tests - debugging API' }
DebuggerSelectorTest >> testDebugMethodInProcessFromContextLabeled [
	self fail
]

{ #category : #'tests - debugging API' }
DebuggerSelectorTest >> testDebugProcessFromContextLabeled [
	self fail
]

{ #category : #'tests - debugging API' }
DebuggerSelectorTest >> testDebuggerWarningFrom [
	self fail
]

{ #category : #'tests - debugging API' }
DebuggerSelectorTest >> testDebuggerWarningInProcessFrom [
	self fail
]

{ #category : #'tests - debuggers' }
DebuggerSelectorTest >> testDebuggersWithRanks [
	|assocs systemDebuggers|
	self fail.
	assocs := DebuggerSelector debuggersWithRanks.
	systemDebuggers := Smalltalk tools debuggers.
	self assert: assocs size equals: systemDebuggers size.
	self assertCollection: assocs equals: systemDebuggers

]

{ #category : #'tests -  algorithm' }
DebuggerSelectorTest >> testFindDebuggerForDebuggerFailure [
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
DebuggerSelectorTest >> testFindDebuggerToHandleContext [
	self
		assert: (debuggerSelector findDebuggerForSession: self session)
		identicalTo: debuggers second
]

{ #category : #'tests - debuggers' }
DebuggerSelectorTest >> testLabeledDebuggers [
	| dbgs labeledDebuggers |
	self fail.
	dbgs := {(999 -> 'main dbg').
	(80 -> 'a dbg').
	(5 -> 'another dbg')}.
	labeledDebuggers := DebuggerSelector labeledDebuggers: dbgs.
	self assert: labeledDebuggers first key equals: 'main dbg'.
	self assert: labeledDebuggers first value equals: 'Main'.
	self assert: labeledDebuggers second key equals: 'a dbg'.
	self assert: labeledDebuggers second value equals: '80'.
	self assert: labeledDebuggers third key equals: 'another dbg'.
	self assert: labeledDebuggers third value equals: '5'
]

{ #category : #'tests - sessions' }
DebuggerSelectorTest >> testNewSessionFromExceptionForProcess [
]

{ #category : #'tests -  algorithm' }
DebuggerSelectorTest >> testNoDebuggerForDebuggerFailure [
	| process semaphore exception session |
	semaphore := Semaphore new.
	process := [ [ 1 / 0 ]
		on: Error
		do: [ :err | exception := DebuggerFailure of: debuggers second on: err ] ]
		newProcess.
	[[ process resume ]
		ensure: [ semaphore signal ]] fork.
	semaphore wait.
	
	exception := DebuggerFailure of: debuggers third on: exception.
	session := debuggerSelector
		newSessionFromException: exception
		forProcess: process.
		
	self
		assert: (debuggerSelector findDebuggerForSession: session) identicalTo: Transcripter
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testNullExceptionForNamed [
	|ctx e|
	ctx := Context newForMethod: (DummyDebugger>>#tag).
	ctx receiver: self.
	e := NewDebuggerSelector nullExceptionFor: ctx named: #tag.
	self assert: e receiver identicalTo: self.
	self assert: e signalerContext identicalTo: ctx.
	self assert: e messageText equals: #tag
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testOpenOn [
	"Basically openOn: finds a debugger and calls tryOpen:on:.
	So the first usable debugger (second in the list, see setUp)
	should work"
	| session |
	session := self session.
	debuggerSelector openOn: session.
	self assert: debuggers second tag identicalTo: session
]

{ #category : #'tests - sessions' }
DebuggerSelectorTest >> testPerformPreDebugActionsOn [
	self fail
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testPreDebugActionForDebugItMethod [
	| tag |
	"Default debug action is an empty block with 1 parameter"
	debuggerSelector performPreDebugActionsOn: #tag.
	
	"Custom debug action should execute the give block"
	debuggerSelector preDebugAction: [ :session | tag := session ].
	debuggerSelector performPreDebugActionsOn: #tag.
	self assert: tag equals: #tag
]

{ #category : #'tests - debuggers' }
DebuggerSelectorTest >> testSortedDebuggersByRank [
	| assocs systemDebuggers sortedRanks expectedRanks |
	self fail.
	assocs := DebuggerSelector sortedDebuggersByRank.
	systemDebuggers := Smalltalk tools debuggers.
	self
		assertCollection: (assocs collect: [ :assoc | assoc value ])
		includesAll: (systemDebuggers collect: [ :assoc | assoc key ]).
	sortedRanks := assocs collect: [ :assoc | assoc key ].
	expectedRanks := (systemDebuggers collect: [ :assoc | assoc value ]) asSortedCollection.
	self assert: sortedRanks equals: expectedRanks asOrderedCollection reversed
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testTryOpenOn [
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
	debugger := DummyDebugger new.
	debuggerSelector tryOpen: debugger on: session.
	self assert: debugger tag identicalTo: session
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testWith [
	|trace|
	trace := Object new.
	self assert: (NewDebuggerSelector with: trace) availableDebuggers identicalTo: trace
]
