Class {
	#name : #DSSingleDebuggerSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggers',
		'debuggerSelector'
	],
	#category : #'Debuggers-SelectionStrategies-Tests'
}

{ #category : #running }
DSSingleDebuggerSelectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	debuggers := DSDummyDebugger dummyDebuggerList.
	debuggerSelector := DSSingleDebuggerSelector with: debuggers copy
]

{ #category : #running }
DSSingleDebuggerSelectorTest >> tearDown [
	debuggers
		do: [ :dbg | 
			(dbg tag isKindOf: DebugSession)
				ifTrue: [ dbg tag terminate ] ].
	super tearDown
]

{ #category : #tests }
DSSingleDebuggerSelectorTest >> testError [
	self deny: DSDebuggerSelector new hasErrors
]

{ #category : #tests }
DSSingleDebuggerSelectorTest >> testErrorWhenOpeningDebugger [
	| session |
	session := DSDummyDebugger dummySession.
	debuggers first beError.	
	debuggerSelector openDebuggerForSession: session.
	
	self assert: debuggerSelector hasErrors.
	self assert: debuggerSelector error class identicalTo: Error.
	self deny: debuggerSelector handled
	
]

{ #category : #tests }
DSSingleDebuggerSelectorTest >> testHandled [
	| session |
	session := DSDummyDebugger dummySession.
	debuggers first beError.
	
	self assert: debuggerSelector handled.
	
	debuggerSelector openDebuggerForSession: session.
	self deny: debuggerSelector handled
]

{ #category : #tests }
DSSingleDebuggerSelectorTest >> testNextDebugger [
	self
		assert: debuggerSelector nextDebugger
		identicalTo: debuggers first.
	self
		assert: debuggerSelector nextDebugger
		identicalTo: debuggers first.
	self
		assert: debuggerSelector nextDebugger
		identicalTo: debuggers first
]

{ #category : #tests }
DSSingleDebuggerSelectorTest >> testOpenDebuggerForSession [
	| session |
	session := DSDummyDebugger dummySession.
	
	debuggerSelector openDebuggerForSession: session.
	self assert: debuggers first tag identicalTo: session.	
	
	debuggers first tag: nil.
	debuggerSelector openDebuggerForSession: session.
	self assert: debuggers first tag identicalTo: session.	
	self assert: debuggers second tag equals: nil.
	
	debuggers first tag: nil.
	debuggerSelector openDebuggerForSession: session.
	self assert: debuggers first tag identicalTo: session.	
	self assert: debuggers third tag equals: nil.
]
