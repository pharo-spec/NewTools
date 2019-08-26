Class {
	#name : #WhereIsDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
WhereIsDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 1000>
	^ 'Where is?'
]

{ #category : #default }
WhereIsDebugCommand class >> defaultDescription [
	^ 'Highligh the next method to be executed (step) by the debugger.'
]

{ #category : #initialization }
WhereIsDebugCommand class >> defaultIconName [
	^ #glamorousSearch 
]

{ #category : #default }
WhereIsDebugCommand class >> defaultName [

	^ 'Where is?'
]

{ #category : #initialization }
WhereIsDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
WhereIsDebugCommand >> execute [
	self flag: 'Should the action have this responsibility on the debugger code pane?'.
	self flag: 'Bound to the bytecode execution model.'.
	self debugger code
		setSelection: (self session pcRangeForContext: self currentContext)
]
