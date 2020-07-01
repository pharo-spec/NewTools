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
DebuggerSystemTest >> testAvailableDebuggers [
	"Tests that DebuggerSystem>>#availableDebuggers returns a list"
	self assert: DebuggerSystem new availableDebuggers isSequenceable
	
]

{ #category : #tests }
DebuggerSystemTest >> testHandleDebugRequest [
	"Tests that a DebuggerSystem tasked to handle a DebugRequest calls the #handleDebugRequest: of its uiManager with that DebugRequest"
	| debuggerSystem debugRequest |
	debuggerSystem := DummyDebuggerSystem new.
	debugRequest := DebugRequest basicNew.
	self assert: debuggerSystem defaultUIManager callsToHandleDebugRequest equals: 0.
	debuggerSystem handleDebugRequest: debugRequest.
	self assert: debuggerSystem defaultUIManager callsToHandleDebugRequest equals: 1.
	self assert: debuggerSystem defaultUIManager debugRequestSentToHandleDebugRequest identicalTo: debugRequest
	
]

{ #category : #tests }
DebuggerSystemTest >> testHandleWarningDebugRequest [
	"Tests that a DebuggerSystem tasked to handle a WarningDebugRequest calls the #handleWarningDebugRequest: of its uiManager with that DebugRequest"
	| debuggerSystem debugRequest |
	debuggerSystem := DummyDebuggerSystem new.
	debugRequest := DebugRequest basicNew.
	self assert: debuggerSystem defaultUIManager callsToHandleWarningDebugRequest equals: 0.
	debuggerSystem handleWarningDebugRequest: debugRequest.
	self assert: debuggerSystem defaultUIManager callsToHandleWarningDebugRequest equals: 1.
	self assert: debuggerSystem defaultUIManager debugRequestSentToHandleWarningDebugRequest identicalTo: debugRequest
	
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
