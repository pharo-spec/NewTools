Class {
	#name : #StDebuggerActionModelTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugActionModel',
		'debugger',
		'result'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #helper }
StDebuggerActionModelTest >> session [
	^debugger session
]

{ #category : #helper }
StDebuggerActionModelTest >> setResult [
	result := 2 squared.
	^result
]

{ #category : #running }
StDebuggerActionModelTest >> setUp [
	| method context process |
	super setUp.
	method := self class >> #setResult.
	process := [ method valueWithReceiver: self arguments: #() ]
		newProcess.
	context := process suspendedContext.
	session := process
		newDebugSessionNamed: 'test session'
		startedAt: context.
	session
		stepIntoUntil: [ :currentContext | currentContext method == method ].
	debugger := StDebugger basicNew
		application: StDebugger currentApplication;
		session: session;
		initialize.
	debugger removeSessionHolderSubscriptions.
	debugActionModel := StDebuggerActionModel on: debugger
]

{ #category : #running }
StDebuggerActionModelTest >> tearDown [ 
	session interruptedContext ifNotNil:[session resume].
	super tearDown 
]

{ #category : #tests }
StDebuggerActionModelTest >> testClearDebugSession [
	| process |
	process := session interruptedProcess.
	self deny: process isTerminated.
	debugActionModel clearDebugSession.
	self assert: process isTerminated.
	self assert: session interruptedContext isNil
]

{ #category : #tests }
StDebuggerActionModelTest >> testInitialization [
	self assert: debugActionModel debugger identicalTo: debugger.
	self assert: debugActionModel currentContext identicalTo: debugger currentContext.
	self assert: debugActionModel session identicalTo: session.
	self
		assert: debugActionModel interruptedContext
		identicalTo: session interruptedContext
]

{ #category : #tests }
StDebuggerActionModelTest >> testProceedDebugSession [
	self deny: session interruptedContext isNil.
	self assert: result isNil.
	debugActionModel proceedDebugSession.
	self assert: session interruptedContext isNil.
	self assert: result equals: 4
]

{ #category : #tests }
StDebuggerActionModelTest >> testRestartContext [
	|topContext topPC|
	topContext := 
	session interruptedContext.
	topPC := topContext pc.
	session stepInto.
	self deny: session interruptedContext identicalTo: topContext.
	debugActionModel restartContext: topContext.
	self assert: session interruptedContext identicalTo: topContext.
	self assert: session interruptedContext pc equals: topPC
]

{ #category : #tests }
StDebuggerActionModelTest >> testReturnValueFromExpressionFromContext [
	session stepInto.
	session stepInto.
	debugActionModel returnValueFromExpression: '0' fromContext: session interruptedContext.
	self assert: session interruptedContext top equals: 0.
	session resume.
	self assert: result equals: 0
]

{ #category : #tests }
StDebuggerActionModelTest >> testRunToSelectionInContext [
	|method node|
	method := (self class >> #setResult).
	node :=  method ast statements second.
	debugActionModel runToSelection: (node start to: node stop) inContext: session interruptedContext.
	self assert: result equals: 4.
	self assert: (method sourceNodeForPC: session interruptedContext pc) identicalTo: node
]
