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
	<StackContextMenuEditionDebugCommand>
	^ 'Copy Stack to Clipboard'
]

{ #category : #initialization }
StCopyStackToClipboardDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
StCopyStackToClipboardDebugCommand >> execute [	
	Clipboard clipboardText: (String streamContents: [ :s| 
		self debugger interruptedContext shortDebugStackOn: s ])
]
