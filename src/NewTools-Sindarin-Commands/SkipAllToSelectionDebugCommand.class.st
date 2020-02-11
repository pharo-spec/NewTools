Class {
	#name : #SkipAllToSelectionDebugCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'as yet unclassified' }
SkipAllToSelectionDebugCommand class >> defaultDescription [
	^ 'Jump to the text cursor position without executing code and return debugger control.'
]

{ #category : #initialization }
SkipAllToSelectionDebugCommand class >> defaultIconName [
	^ #glamorousRightSide
]

{ #category : #'as yet unclassified' }
SkipAllToSelectionDebugCommand class >> defaultName [
	<toolbarDebugCommand: 50>
	^ 'Jump to cursor'
]

{ #category : #initialization }
SkipAllToSelectionDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
SkipAllToSelectionDebugCommand >> execute [
	self flag: 'TODO'.
	self inform: 'NOT IMPLEMENTED YET'
]
