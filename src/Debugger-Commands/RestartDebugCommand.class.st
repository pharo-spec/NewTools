Class {
	#name : #RestartDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
RestartDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 900>

	^ 'Restart'
]

{ #category : #default }
RestartDebugCommand class >> defaultDescription [
	^ 'Go back the start of the current execution context, resetting all local variables and take debugger control.'
]

{ #category : #initialization }
RestartDebugCommand class >> defaultIconName [
	^ #glamorousRestart
]

{ #category : #default }
RestartDebugCommand class >> defaultName [

	^ 'Restart'
]

{ #category : #initialization }
RestartDebugCommand class >> defaultShortcut [
	^ PharoShortcuts current restartExecutionShortcut
]

{ #category : #hooks }
RestartDebugCommand >> execute [
	self session restart: self currentContext
]
