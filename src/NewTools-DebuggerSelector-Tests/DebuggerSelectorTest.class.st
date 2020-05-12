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
	self fail
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

{ #category : #tests }
DebuggerSelectorTest >> testGetDebuggerClasses [
	"Test that #getDebuggerClasses returns at least the dummy test classes"

	"We use the #getDebuggerClassesReal method instead of #getDebuggerClasses because it actually calls the standard implementation of #getDebuggerClasses from DebuggerSelector. Unlike #getDebuggerClassesReal which has been overridden to do somethig different for testing purposes. See class DebuggerSelectorForTests"

	| debuggerClasses |
	debuggerClasses := debuggerSelector getDebuggerClassesReal.
	self assert: (debuggerClasses includes: DummyDebugger).
	self assert: (debuggerClasses includes:
			 DummyDebuggerForTests_CannotOpenDebugSession).
	self assert:
		(debuggerClasses includes: DummyDebuggerForTests_RankZero).
	self assert: (debuggerClasses includes: Object) not
]

{ #category : #tests }
DebuggerSelectorTest >> testIsThisClassADebugger [
	self assert:
		(debuggerSelector isThisClassADebugger: DummyDebugger).
	self assert: (debuggerSelector isThisClassADebugger:
			 DummyDebuggerForTests_CannotOpenDebugSession).
	self assert: (debuggerSelector isThisClassADebugger: self class) not
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

{ #category : #tests }
DebuggerSelectorTest >> testMainDebuggerAlgorithm [
	"Tests that the first debugger that DebuggerSelector will try to open is the one that has been set as main debugger, even if another debugger has a higher rank"

	debuggerSelector mainDebuggerClass: DummyDebuggerForTests_RankZero.
	debuggerSelector
		selectAndOpenDebuggerFor: debugSession
		withNotification: nil.
	self
		assert: debuggerSelector debuggerSelectionAttempts size
		equals: 1.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) debuggerClass
		equals: DummyDebuggerForTests_RankZero
]

{ #category : #tests }
DebuggerSelectorTest >> testMainDebuggerAlgorithm_MainDebuggerCannotOpen [
	"Tests that the first debugger that DebuggerSelector will try to open is the one that has been set as main debugger, even if another debugger has a higher rank"

	debuggerSelector
		mainDebuggerClass: DummyDebuggerForTests_CannotOpenDebugSession.
	debuggerSelector
		selectAndOpenDebuggerFor: debugSession
		withNotification: nil.
	self
		assert: debuggerSelector debuggerSelectionAttempts size
		equals: 3.
	"Assert the debuggerSelector tried to open the main debugger first, but failed (as this particular debugger fails to open any debug session)"
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) debuggerClass
		equals: DummyDebuggerForTests_CannotOpenDebugSession.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) success not.
	"Assert that after failing to open the main debugger, the debuggerSelector reverted to the standard algorithm of trying to open the highest ranked debugger first. The highest ranked debugger happen to be DummyDebuggerForTests_CannotOpenDebugSession"
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 2) debuggerClass
		equals: DummyDebuggerForTests_CannotOpenDebugSession.
	"Assert that the next debugger tried could open the debug session"
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 3) debuggerClass
		equals: DummyDebugger.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 3) success
]

{ #category : #tests }
DebuggerSelectorTest >> testMainDebuggerSetGet [
	"Test that setter methods #mainDebuggerClass: and #setNoMainDebuggerClass correctly set the main debugger class. Also test that listeners to main debugger updates do get notified"

	debuggerSelector mainDebuggerClass: DummyDebuggerForTests_RankZero.
	self
		assert: debuggerSelector mainDebuggerClass
		equals: DummyDebuggerForTests_RankZero.
	self
		assert: eventListener nbOfMainDebuggerClassUpdateEventReceived
		equals: 1.
	debuggerSelector setNoMainDebuggerClass.
	self assert: debuggerSelector mainDebuggerClass equals: nil.
	self
		assert: eventListener nbOfMainDebuggerClassUpdateEventReceived
		equals: 2
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
	self fail
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testOpenOn [
	self fail
]

{ #category : #'tests - sessions' }
DebuggerSelectorTest >> testPerformPreDebugActionsOn [
	self fail
]

{ #category : #'tests - debugging' }
DebuggerSelectorTest >> testPreDebugActionForDebugItMethod [
	self fail
]

{ #category : #tests }
DebuggerSelectorTest >> testSelectDebuggerIgnoresDebuggersSayingTheyCannotOpenTheDebugSession [
	"Test that the debugger selection algorithm ignores debuggers that reject the debug session, and choose the next debugger that can open it instead"

	debuggerSelector clearDebuggerClasses.
	debuggerSelector debuggerClasses
		add: DummyDebuggerForTests_RejectAllDebugSessions;
		add: DummyDebuggerForTests_RankZero.
	debuggerSelector
		selectAndOpenDebuggerFor: debugSession
		withNotification: nil.
	self
		assert: debuggerSelector debuggerSelectionAttempts size
		equals: 1.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) debuggerClass
		equals: DummyDebuggerForTests_RankZero
]

{ #category : #tests }
DebuggerSelectorTest >> testSettingNonDebuggerAsMainDebuggerSignalsException [
	"Setting as main debugger a class that is not a debugger should signal a CannotSetAsMainDebuggerAClassThatIsNotADebuggerClass exception"

	self
		should: [ debuggerSelector mainDebuggerClass: Object ]
		raise: CannotSetAsDebugger
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
	self fail
]

{ #category : #tests }
DebuggerSelectorTest >> testTryToOpenDebugSession [
	"The purpose of this test is to check that the instrumentation of #tryToOpenDebugSession:withDebuggerClass:withFullView:andNotification: on DebuggerSelectorDecoratorForTest works properly"

	debuggerSelector
		tryToOpenDebugSession: debugSession
		withDebuggerClass: testDebuggerClass
		andNotification: nil.
	self
		assert: debuggerSelector debuggerSelectionAttempts size
		equals: 1.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) success.
	self
		assert: (debuggerSelector debuggerSelectionAttempts at: 1) debuggerClass
		equals: testDebuggerClass
]
