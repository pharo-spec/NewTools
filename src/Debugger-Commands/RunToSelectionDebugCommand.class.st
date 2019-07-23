Class {
	#name : #RunToSelectionDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #'as yet unclassified' }
RunToSelectionDebugCommand class >> defaultCommandName [
	<ToolbarDebugCommand>
	^ 'Run to'
]

{ #category : #'as yet unclassified' }
RunToSelectionDebugCommand class >> defaultDescription [
	^ 'Execute methods up to the text cursor position and return debugger control.'
]

{ #category : #initialization }
RunToSelectionDebugCommand class >> defaultIconName [
	^ #glamorousRightSide
]

{ #category : #initialization }
RunToSelectionDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
RunToSelectionDebugCommand >> execute [
	self session
		runToSelection: self debugger code getSelection
		inContext: self currentContext
]
