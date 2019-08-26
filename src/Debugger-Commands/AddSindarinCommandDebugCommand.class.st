Class {
	#name : #AddSindarinCommandDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
AddSindarinCommandDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 9997>
	
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

{ #category : #default }
AddSindarinCommandDebugCommand class >> defaultName [
	
	^ 'New Cmd'
]

{ #category : #initialization }
AddSindarinCommandDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
AddSindarinCommandDebugCommand >> execute [
	
	| creationDialog |
	creationDialog := CreateAnonymousDebugCommandPresenter new openWithSpec.
	"DebugCommand newAnonymousActionLabeled: 'Test' icon: 'abstract' executeScript: 'self debugger inspect'."
	creationDialog whenClosedDo: [ self debugger updateToolbar]
]
