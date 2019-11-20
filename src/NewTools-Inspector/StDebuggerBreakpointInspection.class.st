Class {
	#name : #StDebuggerBreakpointInspection,
	#superclass : #StObjectBreakpointInspection,
	#category : #'NewTools-Inspector-View'
}

{ #category : #private }
StDebuggerBreakpointInspection >> breakPointsForModel [
	^ Breakpoint all
]

{ #category : #private }
StDebuggerBreakpointInspection >> buildHaltData [
	^ StHaltCache defaultCache methodsWithHalts values flattened
		collect: [ :node | self haltDataFor: node ]
]
