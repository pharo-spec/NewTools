Class {
	#name : #SindarinSkipAllToSelectionCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #initialization }
SindarinSkipAllToSelectionCommand class >> defaultIconName [
	^ #glamorousRightSide
]

{ #category : #hooks }
SindarinSkipAllToSelectionCommand >> execute [
	|selectionInterval targetNode skipTargetNode|
	self flag: 'Context should actually be a debugger or a sindarin debugger'.
	self flag: 'Suspicious call to internal debugger UI state'.
	selectionInterval := self context code selectionInterval.
	skipTargetNode := false.
	selectionInterval isEmpty ifTrue:[ |cursorPosition|
		cursorPosition := self context code cursorPositionIndex .
		self context code selectLine.	
		
		selectionInterval := self context code selectionInterval.
		skipTargetNode := selectionInterval last <= cursorPosition.
		].

	targetNode := self context sindarinDebugger bestNodeFor: selectionInterval.
	self context sindarinDebugger skipUpToNode: targetNode skipTargetNode: skipTargetNode.
	self context forceSessionUpdate 
]
