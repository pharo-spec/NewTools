"
I am a dummy DebugRequest, used for testing
"
Class {
	#name : #DummyDebugRequest,
	#superclass : #DebugRequest,
	#instVars : [
		'dummyPreDebugActionExecutedCount'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #preDebugActions }
DummyDebugRequest >> computePreDebugActions [
	"For test purposes. Instead of computing preDebugActions as usual, insert a dummy pre debug action"
	self preDebugActions add: [:dbSession|  dummyPreDebugActionExecutedCount := self dummyPreDebugActionExecutedCount + 1 ]
]

{ #category : #preDebugActions }
DummyDebugRequest >> dummyPreDebugActionExecutedCount [
	dummyPreDebugActionExecutedCount ifNil: [ dummyPreDebugActionExecutedCount := 0 ].
	^ dummyPreDebugActionExecutedCount
]
