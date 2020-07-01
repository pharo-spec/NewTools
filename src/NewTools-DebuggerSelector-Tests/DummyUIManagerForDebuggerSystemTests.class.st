"
A dummy UIManager used to test DebuggerSystem
"
Class {
	#name : #DummyUIManagerForDebuggerSystemTests,
	#superclass : #Object,
	#instVars : [
		'callsToHandleDebugRequest',
		'callsToHandleWarningDebugRequest',
		'debugRequestSentToHandleDebugRequest',
		'debugRequestSentToHandleWarningDebugRequest'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> callsToHandleDebugRequest [
	callsToHandleDebugRequest ifNil: [ callsToHandleDebugRequest := 0 ].
	^ callsToHandleDebugRequest
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> callsToHandleDebugRequest: aValue [
	callsToHandleDebugRequest := aValue
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> callsToHandleWarningDebugRequest [
	callsToHandleWarningDebugRequest ifNil: [ callsToHandleWarningDebugRequest := 0 ].
	^ callsToHandleWarningDebugRequest
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> callsToHandleWarningDebugRequest: aValue [
	callsToHandleWarningDebugRequest := aValue
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> debugRequestSentToHandleDebugRequest [
	^ debugRequestSentToHandleDebugRequest
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> debugRequestSentToHandleWarningDebugRequest [
	^ debugRequestSentToHandleWarningDebugRequest
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> handleDebugRequest: aDebugRequest [
	"Increment a counter to measure how many times this method was called"
	self callsToHandleDebugRequest: self callsToHandleDebugRequest + 1.
	debugRequestSentToHandleDebugRequest := aDebugRequest
]

{ #category : #'handle debug requests' }
DummyUIManagerForDebuggerSystemTests >> handleWarningDebugRequest: aDebugRequest [
	"Increment a counter to measure how many times this method was called"
	self callsToHandleWarningDebugRequest: self callsToHandleWarningDebugRequest + 1.
	debugRequestSentToHandleWarningDebugRequest := aDebugRequest
]
