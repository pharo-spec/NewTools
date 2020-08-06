"
I am a data holder for halts and breakpoints to be displayed in StObjectBreakpointInspection tables.
"
Class {
	#name : #StHaltInspectionItem,
	#superclass : #Object,
	#instVars : [
		'node',
		'type',
		'interval',
		'displayEntity',
		'scope'
	],
	#category : #'NewTools-Debugger-Breakpoints-Tools-Presenters'
}

{ #category : #'as yet unclassified' }
StHaltInspectionItem class >> forBreakpoint: aBreakpoint [ 
	^StBreakpointInspectionItem new forBreakpoint: aBreakpoint 
]

{ #category : #'as yet unclassified' }
StHaltInspectionItem class >> forHalt: aRBMessageNode [ 
	^self new forHalt: aRBMessageNode
]

{ #category : #accessing }
StHaltInspectionItem >> displayEntity [
	^ displayEntity
]

{ #category : #initialization }
StHaltInspectionItem >> forHalt: aRBMessageNode [ 
	node := aRBMessageNode.
	type := Halt name asString.
	interval := node start to: node stop.
	scope := aRBMessageNode methodNode methodClass.
	displayEntity := aRBMessageNode methodNode
]

{ #category : #accessing }
StHaltInspectionItem >> interval [
	^ interval
]

{ #category : #accessing }
StHaltInspectionItem >> interval: anObject [
	interval := anObject
]

{ #category : #accessing }
StHaltInspectionItem >> node [
	^ node
]

{ #category : #accessing }
StHaltInspectionItem >> node: anObject [
	node := anObject
]

{ #category : #printing }
StHaltInspectionItem >> printContents [
	^displayEntity sourceCode
]

{ #category : #printing }
StHaltInspectionItem >> printEntity [
	self flag: #TEST.
	^displayEntity method printString
]

{ #category : #printing }
StHaltInspectionItem >> printScope [

	^ scope printString
]

{ #category : #accessing }
StHaltInspectionItem >> scope [
	^ scope
]

{ #category : #accessing }
StHaltInspectionItem >> scope: anObject [
	scope := anObject
]

{ #category : #accessing }
StHaltInspectionItem >> type [
	^ type
]

{ #category : #accessing }
StHaltInspectionItem >> type: anObject [
	type := anObject
]

{ #category : #updating }
StHaltInspectionItem >> updateSourceCodePaneFor: aStObjectBreakpointInspection [ 
	aStObjectBreakpointInspection updateSourceCodeForHaltItem: self
]
