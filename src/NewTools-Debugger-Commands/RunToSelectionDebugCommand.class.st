Class {
	#name : #RunToSelectionDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #'as yet unclassified' }
RunToSelectionDebugCommand class >> defaultDescription [
	^ 'Execute methods up to the text cursor position and return debugger control.'
]

{ #category : #initialization }
RunToSelectionDebugCommand class >> defaultIconName [
	^ #glamorousRightSide
]

{ #category : #'as yet unclassified' }
RunToSelectionDebugCommand class >> defaultName [
	<toolbarDebugCommand: 50>
	^ 'Run to'
]

{ #category : #initialization }
RunToSelectionDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
RunToSelectionDebugCommand >> execute [
	self flag: 'Such access to the debugger internal state is suspicious...'.
	self session
		runToSelection: self debugger code selectionInterval
		inContext: self currentContext
]
