"
Requests the debugger to copy its stack on the Clipboard
"
Class {
	#name : #StCopyStackToClipboardDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #initialization }
StCopyStackToClipboardDebugCommand class >> defaultDescription [
	^ 'Copy a short debugging stack to the clipboard.'
]

{ #category : #initialization }
StCopyStackToClipboardDebugCommand class >> defaultIconName [
	^ #smallCopy
]

{ #category : #initialization }
StCopyStackToClipboardDebugCommand class >> defaultName [
	^ 'Copy Stack to Clipboard'
]

{ #category : #initialization }
StCopyStackToClipboardDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
StCopyStackToClipboardDebugCommand >> execute [
	self debugger copyStackToClipboard
]
