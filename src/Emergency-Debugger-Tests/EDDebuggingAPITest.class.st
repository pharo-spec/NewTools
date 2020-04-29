Class {
	#name : #EDDebuggingAPITest,
	#superclass : #EDTests,
	#category : #'Emergency-Debugger-Tests'
}

{ #category : #helpers }
EDDebuggingAPITest >> forbiddenProcesses [
	self flag: 'This is a fixed list of processes we do not want to kill if they exist. This is too magickal, but we lack tools to have such information and we do not want to depend on process browser packages (information is taken from there).'.
	^ {[  ].
	[ Smalltalk lowSpaceWatcherProcess ].
	[ WeakArray runningFinalizationProcess ].
	[ Processor backgroundProcess ].
	[ InputEventFetcher default fetcherProcess ].
	[ UIManager default uiProcess ].
	[ Delay schedulingProcess ]}
]

{ #category : #'tests - processes' }
EDDebuggingAPITest >> testAllRunningProcesses [
	| processes |
	processes := EDDebuggingAPI allRunningProcesses.
	self assertCollection: Process allSubInstances includesAll: processes.
	self
		denyCollection: processes
		includesAny: EDDebuggingAPI forbiddenProcesses.
	processes do: [ :p | self deny: p isTerminated ]
]

{ #category : #'tests - initialization' }
EDDebuggingAPITest >> testAttachTo [
	self assert: debugAPI session identicalTo: session
]

{ #category : #'tests - debugging support' }
EDDebuggingAPITest >> testCloseEmergencySession [

	|ed|
	ed := EDEmergencyDebugger new.
	ed basicDebug: session.
	ed debugAPI closeEmergencySession.
	self deny: ed isRunning
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testContextAt [
	1 to: session stack size do: [ :i | 
		self
			assert: (debugAPI contextAt: i)
			identicalTo: (session stack at: i) ]
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testDisplayStackSize [
	self
		assert: debugAPI displayStackSize
		equals: debugAPI class displayStackSize
]

{ #category : #'tests - processes' }
EDDebuggingAPITest >> testForbiddenProcesses [
	EDDebuggingAPI forbiddenProcesses
		with: self forbiddenProcesses
		do:
			[ :actualProcess :expectedProcess | self assert: actualProcess value identicalTo: expectedProcess value ]
]

{ #category : #'tests - initialization' }
EDDebuggingAPITest >> testInitialize [
	self assert: debugAPI debugger isNil.
	self assertEmpty: debugAPI changesForMethods
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testLongStack [
	self
		assertCollection: debugAPI longStack
		equals: (session stackOfSize: debugAPI longStackSize)
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testLongStackSize [
	self
		assert: debugAPI longStackSize
		equals: debugAPI class longStackSize
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testMethodAt [
	1 to: session stack size do: [ :i | 
		self
			assert: (debugAPI methodAt: i)
			identicalTo: (session stack at: i) method ]
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testNodeAt [
	1 to: session stack size do: [ :i | 
		| context |
		context := session stack at: i.
		self
			assert: (debugAPI nodeAt: i)
			identicalTo: (context method sourceNodeForPC: context pc) ]
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testNodeForContext [
	| context |
	context := session stack first.
	self
		assert: (debugAPI nodeForContext: context)
		identicalTo: (context method sourceNodeForPC: context pc)
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testStack [ 
	self assert: debugAPI stack identicalTo: debugAPI longStack
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testStackAt [
	1 to: session stack size do:
		[ :i | self assert: (debugAPI stackAt: i) equals: (session stack at: i) ]
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testStackFromTo [
	| stackExtract |
	stackExtract := (session stack copyFrom: 5 to: 10).
	self
		assertCollection: (debugAPI stackFrom: 5 to: 10)
		equals: stackExtract
]

{ #category : #'tests - stack' }
EDDebuggingAPITest >> testStackSize [
	self
		assert: debugAPI stackSize
		equals: debugAPI stack size
]

{ #category : #'tests - processes' }
EDDebuggingAPITest >> testTerminateAllProcesses [
	|edProcess|
	edProcess := ed debugAPI session interruptedProcess.
	ed debugAPI terminateAllProcesses.
	self assert: edProcess isTerminated 
]

{ #category : #'tests - debugging support' }
EDDebuggingAPITest >> testTerminateSession [

	|ed process|
	ed := EDEmergencyDebugger new.
	ed basicDebug: session.
	process := ed debugAPI session interruptedProcess.
	ed debugAPI terminateSession.
	self assert: ed debugAPI session interruptedProcess isNil.
	self assert: process isTerminated
]
