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
	result := 2 squared
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
StDebuggerActionModelTest >> testReturnValueFromExpression [
	session stepInto.
	session stepInto.
	debugActionModel returnValueFromExpression: '0' fromContext: session interruptedContext.
	self assert: session interruptedContext top equals: 0.
	session resume.
	self assert: result equals: 0
]
