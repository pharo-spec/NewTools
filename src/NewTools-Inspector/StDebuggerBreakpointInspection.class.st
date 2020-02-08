Class {
	#name : #StDebuggerBreakpointInspection,
	#superclass : #StObjectBreakpointInspection,
	#classInstVars : [
		'showInDebugger'
	],
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
	<debuggerExtension>
	^ 'Breakpoints'
]

{ #category : #accessing }
StDebuggerBreakpointInspection class >> showInDebugger [
	^ showInDebugger ifNil:[showInDebugger := false]
]

{ #category : #accessing }
StDebuggerBreakpointInspection class >> showInDebugger: anObject [
	showInDebugger := anObject
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
