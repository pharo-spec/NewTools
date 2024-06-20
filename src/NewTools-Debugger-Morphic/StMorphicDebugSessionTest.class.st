Class {
	#name : 'StMorphicDebugSessionTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Debugger-Morphic',
	#package : 'NewTools-Debugger-Morphic'
}

{ #category : 'utilities' }
StMorphicDebugSessionTest >> createDebugSessionForNotUIProcess [

	| exception nonUIProcess request |
	nonUIProcess := [ 1 + 1 ] newProcess.
	[ Exception signal ]
		on: Exception
		do: [ :e | exception := e ].
	request := (OupsDummyDebugRequest newForException: exception)
		           process: nonUIProcess;
		           yourself.
	^ StMorphicDebugSessionForTests newFromSession: request debugSession 
]

{ #category : 'utilities' }
StMorphicDebugSessionTest >> createDebugSessionForUIProcess [

	| exception request |
	[ Exception signal ]
		on: Exception
		do: [ :e | exception := e ].
	request := (OupsDummyDebugRequest newForException: exception)
		           process: MorphicUIManager uiProcess;
		           yourself.
	^ StMorphicDebugSessionForTests newFromSession: request debugSession
]

{ #category : 'utilities' }
StMorphicDebugSessionTest >> testNonUIProcessIsRecognised [
	"Tests that a DebuggerSystem opening a DebugRequest that is NOT on the ui process does NOT spawn a new UI process"

	| morphicDebugSession |
	morphicDebugSession := self createDebugSessionForNotUIProcess.
	self deny: morphicDebugSession errorWasInUIProcess.
	self deny: morphicDebugSession newUIProcessSpawned
]

{ #category : 'tests' }
StMorphicDebugSessionTest >> testUIProcessIsRecognised [
	"Test that a DebuggerSystem opening a DebugRequest on the ui process will spawn a new UI process"

	| morphicDebugSession |
	morphicDebugSession := self createDebugSessionForUIProcess.
	self assert: morphicDebugSession errorWasInUIProcess.
	self assert: morphicDebugSession newUIProcessSpawned
]
