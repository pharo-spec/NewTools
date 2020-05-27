"
Requests the debugger to step into the next expression evaluation
"
Class {
	#name : #StepIntoDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StepIntoDebugCommand class >> defaultDescription [
	^ 'Step in the highlighted message, i.e. follow the sent message, taking debugger control in the method invoked.'
]

{ #category : #initialization }
StepIntoDebugCommand class >> defaultIconName [
	^ #glamorousInto
]

{ #category : #default }
StepIntoDebugCommand class >> defaultName [
	<toolbarDebugCommand: 20>
	
	^ 'Into'
]

{ #category : #initialization }
StepIntoDebugCommand class >> defaultShortcut [
	^ PharoShortcuts current stepIntoShortcut
]

{ #category : #hooks }
StepIntoDebugCommand >> execute [
	self debugger stepInto
]
