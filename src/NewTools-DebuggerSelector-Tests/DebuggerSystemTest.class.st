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
	| debuggerSystem |
	debuggerSystem := DummyDebuggerSystem new.
	debuggerSystem openDebuggerOnRequest: self createDummyDebugRequestForNotUIProcess.
	self assert: debuggerSystem newUIProcessSpawned not
	
]

{ #category : #tests }
DebuggerSystemTest >> testPreDebugActionExecuted [
	| debuggerSystem debugRequest |
	debuggerSystem := DummyDebuggerSystem new.
	debugRequest := self createDummyDebugRequest.
	debuggerSystem openDebuggerOnRequest: debugRequest.
	self assert: debugRequest dummyPreDebugActionExecuted
	
]

{ #category : #tests }
DebuggerSystemTest >> testUIProcessIsRecognised [
	| debuggerSystem |
	debuggerSystem := DummyDebuggerSystem new.
	debuggerSystem openDebuggerOnRequest: self createDummyDebugRequestForUIProcess.
	self assert: debuggerSystem newUIProcessSpawned
	
]
