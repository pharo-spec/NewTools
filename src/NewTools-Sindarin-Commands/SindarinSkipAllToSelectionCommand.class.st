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
	^ 'Jump to cursor'
]

{ #category : #initialization }
SindarinSkipAllToSelectionCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
SindarinSkipAllToSelectionCommand >> execute [
	self flag: 'TODO'.
	self inform: 'NOT IMPLEMENTED YET'
]
