Class {
	#name : #StDebuggerCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'session'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithDNUContext [
	[ Object new toto ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> newDebugger [
	^ StDebugger basicNew
		session: session;
		yourself
]

{ #category : #helpers }
StDebuggerCommandTest >> sessionFor: aContext [
	| process |
	process := Process
		forContext: aContext
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: aContext
]

{ #category : #running }
StDebuggerCommandTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp
]

{ #category : #running }
StDebuggerCommandTest >> tearDown [ 
	session terminate.
	super tearDown
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsApplyToDNUContext [

	|debugger|
	debugger := self debuggerWithDNUContext.
]
