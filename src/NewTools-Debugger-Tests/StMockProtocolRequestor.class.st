"
I override GUI requests of protocol for testing by returning a default value.
"
Class {
	#name : #StMockProtocolRequestor,
	#superclass : #StDebuggerProtocolRequestor,
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #'ui requests' }
StMockProtocolRequestor class >> requestProtocolFor: aMethod [
	^self stDebuggerTestProtocol
]

{ #category : #'ui requests' }
StMockProtocolRequestor class >> stDebuggerTestProtocol [
	^'StDebugger test protocol'
]
