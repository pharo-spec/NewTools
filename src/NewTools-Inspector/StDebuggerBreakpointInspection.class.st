Class {
	#name : #StDebuggerBreakpointInspection,
	#superclass : #StObjectBreakpointInspection,
	#instVars : [
		'header'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StDebuggerBreakpointInspection class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #header
			expand: false
			fill: false
			padding: 0;
		add:
			(SpPanedLayout newVertical
				add: #methodsWithBreakpoints;
				add: #breakpointsInSourceCode;
				yourself);
		yourself
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
	header := self instantiate: StHeaderBar.
	header label: self labelString.
	super initializePresenters.
]

{ #category : #accessing }
StDebuggerBreakpointInspection >> labelString [
	^ 'Breakpoints and Halts'
]

{ #category : #presenters }
StDebuggerBreakpointInspection >> updateSourceCodeBehaviorFor: node [
	breakpointsInSourceCode behavior: node methodNode methodClass
]
