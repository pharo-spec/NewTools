Class {
	#name : #StDebuggerBreakpointInspection,
	#superclass : #StObjectBreakpointInspection,
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StDebuggerBreakpointInspection class >> defaultSpec [
	^ SpPanedLayout newVertical
		add: #methodsWithBreakpoints;
		add: #breakpointsInSourceCode;
		yourself
]

{ #category : #specs }
StDebuggerBreakpointInspection class >> extendedDebuggingToolTitle [
	<debuggerExtensionPresentationOrder: 1>
	^ 'Breakpoints and Halts'
]

{ #category : #private }
StDebuggerBreakpointInspection >> breakPointsForModel [
	^ Breakpoint all
]

{ #category : #private }
StDebuggerBreakpointInspection >> buildHaltData [
	^ StHaltCache defaultCache methodsWithHalts values flattened
		collect: [ :node | self haltDataFor: node ]
]

{ #category : #initialization }
StDebuggerBreakpointInspection >> initializePresenters [
	super initializePresenters
]

{ #category : #presenters }
StDebuggerBreakpointInspection >> updateSourceCodeBehaviorFor: node [
	breakpointsInSourceCode behavior: node methodNode methodClass
]
