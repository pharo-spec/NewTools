Class {
	#name : #StDebuggerActionModelTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugActionModel',
		'debugger'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #running }
StDebuggerActionModelTest >> setUp [
	| context process |
	super setUp.
	context := [ 1 squared ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: context.
	debugger := StDebugger basicNew
		application: StDebugger currentApplication;
		session: session;
		initialize.
	debugActionModel := StDebuggerActionModel on: debugger
]

{ #category : #running }
StDebuggerActionModelTest >> testInitialization [
	self assert: debugActionModel debugger identicalTo: debugger.
	self assert: debugActionModel currentContext identicalTo: debugger currentContext.
	self assert: debugActionModel session identicalTo: session.
	self
		assert: debugActionModel interruptedContext
		identicalTo: session interruptedContext
]
