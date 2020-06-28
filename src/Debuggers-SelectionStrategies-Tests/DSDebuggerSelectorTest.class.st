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

{ #category : #tests }
DSDebuggerSelectorTest >> testDebuggers [
	self
		assertCollection: debuggerSelector debuggers asOrderedCollection
		equals: debuggers
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

{ #category : #tests }
DSDebuggerSelectorTest >> testNextDebugger [
	debuggers
		do: [ :dbg | self assert: debuggerSelector nextDebugger identicalTo: dbg ]
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testNextDebuggerForSession [
	"Upon a debugger failure, we call the nextDebuggerForSession: interface to get the next debugger"
	
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
DSDebuggerSelectorTest >> testOpenOn [
	"Basically openOn: finds a debugger and calls tryOpen:on:.
	So the first usable debugger (second in the list, see setUp)
	should work"
	| session |
	session := self session.
	debuggerSelector openOn: session.
	self assert: debuggers second tag identicalTo: session
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
