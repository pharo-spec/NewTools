"
I am a dummy DebugRequest, used for testing
"
Class {
	#name : #DummyDebugRequest,
	#superclass : #DebugRequest,
	#instVars : [
		'dummyPreDebugActionExecuted'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #preDebugActions }
DummyDebugRequest >> computePreDebugActions [
	"For test purposes. Instead of computing preDebugActions as usual, insert a dummy pre debug action"
	self preDebugActions add: [:dbSession|  dummyPreDebugActionExecuted := true ]
]

{ #category : #preDebugActions }
DummyDebugRequest >> dummyPreDebugActionExecuted [
	dummyPreDebugActionExecuted ifNil: [ dummyPreDebugActionExecuted := false ].
	^ dummyPreDebugActionExecuted
]
