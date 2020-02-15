Class {
	#name : #StDebuggerStackCommandTreeBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'debugger',
		'rootGroup'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #running }
StDebuggerStackCommandTreeBuilderTest >> setUp [
	| context process |
	super setUp.
	context := [ ^1 + 1 ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: context.
	debugger := SpecDebugger basicNew
		session: session;
		initialize.
	debugger stackTable selectItem: debugger stackTable items first.
	rootGroup := (CmCommandGroup named: 'root') asSpecGroup
]
