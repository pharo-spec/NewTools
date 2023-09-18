Class {
	#name : #SindarinCommandsTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor',
		'object',
		'debugger'
	],
	#category : #'NewTools-Sindarin-Commands-Tests'
}

{ #category : #running }
SindarinCommandsTest >> setUp [
	super setUp.
	
	visitor := SindarinTestVisitor new.
	object := SindarinTestObjectToVisit new
]

{ #category : #running }
SindarinCommandsTest >> tearDown [

	debugger ifNotNil: [ 
		debugger debuggerActionModel clear.
		debugger session ifNotNil: [ :s | s clear ].
		debugger session: nil.
		debugger := nil ].
	super tearDown
]

{ #category : #'tests - step to instance creation' }
SindarinCommandsTest >> testDebuggerOnNextInstanceCreation [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ Object new ] asContext) debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	command := SindarinStepToNextInstanceCreation forContext: debugger.
	command execute.
	self
		assert: debugger session context method
		identicalTo: (Object class lookupSelector: #new).
	self assert: debugger session context receiver identicalTo: Object
]

{ #category : #'tests - step to instance creation' }
SindarinCommandsTest >> testNoNextInstanceCreationAfterMaxSearchDepth [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ object acceptVisitor: visitor ] asContext)
		                    debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (object class >> #acceptVisitor:) ].

	command := SindarinStepToNextInstanceCreation forContext: debugger.
	command execute.
	self
		assert: command errorString
		equals: command notFoundInCurrentContextString
]

{ #category : #'tests - step to instance creation' }
SindarinCommandsTest >> testNoNextInstanceCreationBeforeContextReturn [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ object doNotAcceptVisitor: nil ] asContext)
		                    debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	command := SindarinStepToNextInstanceCreation forContext: debugger.
	command maxDepth: 2.
	command execute.
	self assert: command errorString equals: command notFoundErrorString
]

{ #category : #'tests - step to next call' }
SindarinCommandsTest >> testStepToNextCallInClass [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ visitor visit: object ] asContext)
		                    debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #visit:) ].
	command := SindarinStepToNextCallInClassCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visit:.
	command execute.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitTestObject:
]

{ #category : #'tests - step to next call' }
SindarinCommandsTest >> testStepToNextCallInClassFailure [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ visitor doNotVisit: object ] asContext)
		                    debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #doNotVisit:) ].
	command := SindarinStepToNextCallInClassCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #doNotVisit:.
	command execute.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #doNotVisit:
]

{ #category : #'tests - step to next call' }
SindarinCommandsTest >> testStepToNextCallInClassNeverFinishes [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
			 [ visitor visitNeverFinish: object ] asContext) debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #visitNeverFinish:) ].
	command := SindarinStepToNextCallInClassCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitNeverFinish:.
	command execute.
	
	"We're stuck in a loop so the debugger interrupted..."
	self
		assert: debugger session context method selector
		equals: #timesRepeat:.
	self assert: debugger session context receiver equals: 10000
]

{ #category : #'tests - step to next call' }
SindarinCommandsTest >> testStepToNextCallInClassWithError [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
			 [ visitor visitWithError: object ] asContext) debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #visitWithError:) ].
	command := SindarinStepToNextCallInClassCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitWithError:.
	command execute.
	self
		assert: debugger session context method selector
		equals: #doesNotUnderstand:
]

{ #category : #'tests - step to next call' }
SindarinCommandsTest >> testStepToNextCallInObject [

	| command originalReceiver dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     [ visitor visitMultipleObjects: object ]
			                     asContext) debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #visitMultipleObjects:) ].
	command := SindarinStepToNextCallInObjectCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitMultipleObjects:.
	originalReceiver := debugger session context receiver.
	command execute.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitTestObject:.
	self
		assert: debugger session context receiver
		identicalTo: originalReceiver
]

{ #category : #'tests - step to instance creation' }
SindarinCommandsTest >> testStepToNextInstanceCreation [

	| command dummyActionModel |
	debugger := SindarinTestCommandDebugger new.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
			 [ object createInstanceWithNew ] asContext) debuggerActionModel.
	debugger session: dummyActionModel session.
	dummyActionModel clear.

	command := SindarinStepToNextInstanceCreation forContext: debugger.
	command execute.
	self
		assert: debugger session context method
		identicalTo: (object class class lookupSelector: #new).
	self assert: debugger session context receiver identicalTo: object class
]
