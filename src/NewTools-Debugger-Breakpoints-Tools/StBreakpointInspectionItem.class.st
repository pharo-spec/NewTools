"
I am a data holder for breakpoints to be displayed in StObjectBreakpointInspection tables.
"
Class {
	#name : #StBreakpointInspectionItem,
	#superclass : #StHaltInspectionItem,
	#instVars : [
		'breakpoint'
	],
	#category : #'NewTools-Debugger-Breakpoints-Tools-Presenters'
}

{ #category : #accessing }
StBreakpointInspectionItem >> breakpoint [
	^ breakpoint
]

{ #category : #initialization }
StBreakpointInspectionItem >> buildBreakpointItemFor: aBreakpoint [

	node := aBreakpoint node.
	interval := node start to: node stop.
	type := Break name asString.
	target := aBreakpoint isObjectCentric
		          ifTrue: [ aBreakpoint targetInstance ]
		          ifFalse: [ node methodNode methodClass ].
	displayEntity := aBreakpoint
]

{ #category : #initialization }
StBreakpointInspectionItem >> buildVariableBreakpointItemFor: aVariableBreakpoint [

	type := Break name asString.
	target := aVariableBreakpoint isObjectCentric
		          ifTrue: [ aVariableBreakpoint targetInstance ]
		          ifFalse: [ aVariableBreakpoint targetClassOrMethod ].
	displayEntity := aVariableBreakpoint
]

{ #category : #initialization }
StBreakpointInspectionItem >> forBreakpoint: aBreakpoint [ 
	breakpoint := aBreakpoint.
	^aBreakpoint asBreakpointInspectionItemIn: self
]

{ #category : #printing }
StBreakpointInspectionItem >> printTarget [
	^displayEntity printForBreakpointInspection
]
