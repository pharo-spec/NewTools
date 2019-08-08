Class {
	#name : #AddSindarinCommandDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
AddSindarinCommandDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 9998>
	
	^ 'New Cmd'
]

{ #category : #default }
AddSindarinCommandDebugCommand class >> defaultDescription [
	^ 'Add a customized Sindarin debug command'
]

{ #category : #initialization }
AddSindarinCommandDebugCommand class >> defaultIconName [
	^ #add
]

{ #category : #initialization }
AddSindarinCommandDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
AddSindarinCommandDebugCommand >> execute [
	DebugCommand newAnonymousActionLabeled: 'Test' icon: 'abstract' executeScript: 'self debugger inspect'.
	self debugger updateToolbar
]
