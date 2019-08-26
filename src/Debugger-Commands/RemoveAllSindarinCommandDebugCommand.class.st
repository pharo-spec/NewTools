Class {
	#name : #RemoveAllSindarinCommandDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
RemoveAllSindarinCommandDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 9998>
	
	^ 'Rem Cmd'
]

{ #category : #default }
RemoveAllSindarinCommandDebugCommand class >> defaultDescription [
	^ 'Remove all customized Sindarin debug command'
]

{ #category : #default }
RemoveAllSindarinCommandDebugCommand class >> defaultIconName [
	^ #remotesManagerRemoveRemote
]

{ #category : #default }
RemoveAllSindarinCommandDebugCommand class >> defaultName [

	
	^ 'Rem Cmd'
]

{ #category : #default }
RemoveAllSindarinCommandDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
RemoveAllSindarinCommandDebugCommand >> execute [
	DebugCommand removeAllAnonymousCommands.
	self debugger updateToolbar
]
