Class {
	#name : #CopyStackToClipboardDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #initialization }
CopyStackToClipboardDebugCommand class >> defaultCommandName [
	<StackContextMenuDebugCommand>
	^ 'Copy Stack to Clipboard'
]

{ #category : #initialization }
CopyStackToClipboardDebugCommand class >> defaultDescription [
	^ 'Copy a short debugging stack to the clipboard.'
]

{ #category : #initialization }
CopyStackToClipboardDebugCommand class >> defaultIconName [
	^ #smallCopy
]

{ #category : #initialization }
CopyStackToClipboardDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
CopyStackToClipboardDebugCommand >> execute [
	self flag: 'Where is this command called?'.
	Clipboard clipboardText: (String streamContents: [ :s| 
		self debugger interruptedContext shortDebugStackOn: s ])
]
