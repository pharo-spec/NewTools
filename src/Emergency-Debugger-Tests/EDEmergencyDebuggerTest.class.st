Class {
	#name : #EDEmergencyDebuggerTest,
	#superclass : #TestCase,
	#instVars : [
		'ed',
		'session',
		'currentDebuggingAPI'
	],
	#category : #'Emergency-Debugger-Tests'
}

{ #category : #running }
EDEmergencyDebuggerTest >> configureDebugSession [

	"Configure a debug session and moves it to the following stack:
	 EDMockObjectForTests>>m:
	 EDMockObjectForTests>>m:
	 EDMockObjectForTests>>m:
	 EDMockObjectForTests>>m:
	 [ EDMockObjectForTests new m: 10 ] in UndefinedObject>>DoIt"
	
	session stepThrough.
	session stepOver.
	session stepInto.
	session stepOver.
	session stepOver.
	session stepInto.
	session stepOver.
	session stepOver.
	session stepInto.	
	session stepOver.
	session stepOver.
	session stepInto

]

{ #category : #running }
EDEmergencyDebuggerTest >> newEd [
	ed := EDEmergencyDebugger new.
	ed repl: EDMockREPLInterface new.
	ed displayInterface: EDMockDisplayInterface new.
	ed debug: session

]

{ #category : #running }
EDEmergencyDebuggerTest >> setUp [
	| context process |
	super setUp.	
	currentDebuggingAPI := EDEmergencyDebugger debugAPI.
	EDEmergencyDebugger debugAPI: nil.
	context := [ EDMockObjectForTests new m: 10 ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: context.
	self configureDebugSession.
	self newEd
]

{ #category : #running }
EDEmergencyDebuggerTest >> tearDown [
	EDEmergencyDebugger debugAPI: currentDebuggingAPI.
	session terminate.
	super tearDown
]
