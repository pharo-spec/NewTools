Class {
	#name : #DebuggerSystemTest,
	#superclass : #TestCase,
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #tests }
DebuggerSystemTest >> createDummyDebugRequest [
	| exception |
	[ DummyExceptionForDebuggerSystemTest signal ] on: Exception do: [ :e | exception := e ].
	^ DummyDebugRequest newForException: exception
]

{ #category : #tests }
DebuggerSystemTest >> createDummyDebugRequestForNotUIProcess [
	| exception nonUIProcess |
	nonUIProcess := [  1+1 ] newProcess.
	[ DummyExceptionForDebuggerSystemTest signal ] on: Exception do: [ :e | exception := e ].
	^ (DummyDebugRequest newForException: exception) process: nonUIProcess; yourself.
]

{ #category : #tests }
DebuggerSystemTest >> createDummyDebugRequestForUIProcess [
	| exception |
	[ DummyExceptionForDebuggerSystemTest signal ] on: Exception do: [ :e | exception := e ].
	^ DummyDebugRequest newForException: exception
]

{ #category : #tests }
DebuggerSystemTest >> testNonUIProcessIsRecognised [
	"Tests that a DebuggerSystem opening a DebugRequest that is NOT on the ui process does NOT spawn a new UI process"
	| debuggerSystem |
	debuggerSystem := DummyDebuggerSystem new.
	debuggerSystem openDebuggerOnRequest: self createDummyDebugRequestForNotUIProcess.
	self assert: debuggerSystem newUIProcessSpawned not
	
]

{ #category : #tests }
DebuggerSystemTest >> testPreDebugActionExecuted [
	"Test that a DebuggerSystem opening a DebugRequest with a pre-debug action will execute it exactly once"
	| debuggerSystem debugRequest |
	debuggerSystem := DummyDebuggerSystem new.
	debugRequest := self createDummyDebugRequest.
	self assert: debugRequest dummyPreDebugActionExecutedCount equals: 0.
	debuggerSystem openDebuggerOnRequest: debugRequest.
	self assert: debugRequest dummyPreDebugActionExecutedCount equals: 1
	
]

{ #category : #tests }
DebuggerSystemTest >> testUIProcessIsRecognised [
	"Test that a DebuggerSystem opening a DebugRequest on the ui process will spawn a new UI process"
	| debuggerSystem |
	debuggerSystem := DummyDebuggerSystem new.
	debuggerSystem openDebuggerOnRequest: self createDummyDebugRequestForUIProcess.
	self assert: debuggerSystem newUIProcessSpawned
	
]
