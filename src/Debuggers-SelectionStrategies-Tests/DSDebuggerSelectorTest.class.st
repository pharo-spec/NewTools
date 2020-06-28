Class {
	#name : #DSDebuggerSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggers',
		'debuggerSelector'
	],
	#category : #'Debuggers-SelectionStrategies-Tests'
}

{ #category : #helper }
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

{ #category : #tests }
DSDebuggerSelectorTest >> testDebuggers [
	self
		assertCollection: debuggerSelector debuggers asOrderedCollection
		equals: debuggers
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testFirstUsableDebuggerForSession [
	
	debuggerSelector debuggers first beUnusable.
	debuggerSelector debuggers second beUnusable.

	self
		assert: (debuggerSelector nextDebuggerForSession: self session)
		identicalTo: debuggers third
	
	
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testHandled [
	self deny: debuggerSelector handled
]

{ #category : #'tests - debugging' }
DSDebuggerSelectorTest >> testHandlesDebuggerErrors [
	self deny: debuggerSelector handlesDebuggerErrors.
	debuggerSelector handlesDebuggerErrors: true.
	self assert: debuggerSelector handlesDebuggerErrors
]

{ #category : #tests }
DSDebuggerSelectorTest >> testNextDebugger [
	debuggers
		do: [ :dbg | self assert: debuggerSelector nextDebugger identicalTo: dbg ]
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testNextDebuggerForDebuggerFailure [
	"Upon a debugger failure, we call the nextDebuggerForSession: interface to get the next debugger"
	|session|
	session := self session.
	session exception: (DebuggerFailure of: debuggers first on: session exception).
	self
		assert: (debuggerSelector nextDebuggerForSession: session)
		identicalTo: debuggers second

	
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

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testOpenDebuggerError [
	| session |
	session := self session.
	session exception: (DebuggerFailure of: debuggers first on: session exception).
	debuggers first beError.
	debuggers second beError.
	
	"Because we are debugging a debugger error, we cannot raise another DebuggerFailure:
	we want to find a debugger to debug the failing debugger."
	debuggerSelector handlesDebuggerErrors: true.	
	self shouldnt: [debuggerSelector openDebuggerForSession: session] raise: DebuggerFailure.	
		
	"Because the first debugger originated the debugger failure,
	it is not considered in the algorithm anymore."
	self assert: debuggers first tag equals: nil.
	self assert: debuggers second tag class identicalTo: Error.
	self assert: debuggers third tag identicalTo: session.
	self assert: debuggerSelector handled
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testOpenDebuggerForSession [
	| session |
	session := self session.
	debuggerSelector openDebuggerForSession: session.
	self assert: debuggers first tag identicalTo: session.
	self assert: debuggerSelector handled
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testOpenDebuggerWithErrorForSession [
	| session |
	session := self session.
	debuggers first beError.
	debuggers second beError.			
	debuggerSelector handlesDebuggerErrors: false.
	debuggerSelector openDebuggerForSession: session.
	self assert: debuggers first tag class identicalTo: Error.
	self assert: debuggers second tag class identicalTo: Error.	
	self assert: debuggers third tag identicalTo: session.
	self assert: debuggerSelector handled
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testTryOpenWith [
	| session |
	session := self session.
	self
		shouldnt: [ debuggerSelector tryOpen: session with: debuggers first ]
		raise: DebuggerFailure.
	self assert: debuggers first tag identicalTo: session.
	self assert: debuggerSelector handled
]

{ #category : #'tests -  algorithm' }
DSDebuggerSelectorTest >> testTryOpenWithSignalsError [
	| session |
	session := self session.
	debuggers first beError.
	debuggers second beError.
	
	self
		shouldnt: [ debuggerSelector tryOpen: session with: debuggers first ]
		raise: DebuggerFailure.
	self deny: debuggerSelector handled.	

	debuggerSelector handlesDebuggerErrors: true.
	self
		should: [ debuggerSelector tryOpen: session with: debuggers second ]
		raise: DebuggerFailure.
	self deny: debuggerSelector handled
]
