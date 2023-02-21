"
I toggle the stack filtering in the debugger on and off, and I trigger a debugger update.
"
Class {
	#name : #StDebuggerToggleFilterStackCommand,
	#superclass : #StDebuggerCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StDebuggerToggleFilterStackCommand class >> defaultDescription [
	^'Toggle stack filtering on and off'
]

{ #category : #initialization }
StDebuggerToggleFilterStackCommand class >> defaultIconName [
	^ #changeSorter
]

{ #category : #default }
StDebuggerToggleFilterStackCommand class >> defaultName [ 
	^'Toggle stack filtering'
]

{ #category : #initialization }
StDebuggerToggleFilterStackCommand class >> defaultShortcut [
	self flag: 'Any suggestion for a "configuration" shortcut?'.
	^ nil
]

{ #category : #executing }
StDebuggerToggleFilterStackCommand >> execute [
	StDebuggerActionModel shouldFilterStack: StDebuggerActionModel shouldFilterStack not.
	self context updateStep
]
