Class {
	#name : #SindarinSkipAllToSelectionCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'as yet unclassified' }
SindarinSkipAllToSelectionCommand class >> defaultDescription [
	^ 'Jump to the text cursor position without executing code and return debugger control.'
]

{ #category : #initialization }
SindarinSkipAllToSelectionCommand class >> defaultIconName [
	^ #glamorousRightSide
]

{ #category : #'as yet unclassified' }
SindarinSkipAllToSelectionCommand class >> defaultName [
	<toolbarDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'Skip everything up to cursor'
]

{ #category : #initialization }
SindarinSkipAllToSelectionCommand class >> defaultShortcut [
	^ nil
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
	self context sindarinDebugger skipToPC: targetNode skipToNextNode: skipTargetNode.
	self context forceSessionUpdate 
]
