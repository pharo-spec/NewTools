"
Request the debugger to restart its current context
"
Class {
	#name : #RestartDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

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
	<toolbarDebugCommand: 900>

	^ 'Restart'
]

{ #category : #initialization }
RestartDebugCommand class >> defaultShortcut [
	^ PharoShortcuts current restartExecutionShortcut
]

{ #category : #hooks }
RestartDebugCommand >> execute [
	self debugger restartCurrentContext
]
