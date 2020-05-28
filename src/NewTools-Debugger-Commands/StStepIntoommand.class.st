"
Requests the debugger to step into the next expression evaluation
"
Class {
	#name : #StStepIntoommand,
	#superclass : #StDebuggerCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StStepIntoommand class >> defaultDescription [
	^ 'Step in the highlighted message, i.e. follow the sent message, taking debugger control in the method invoked.'
]

{ #category : #initialization }
StStepIntoommand class >> defaultIconName [
	^ #glamorousInto
]

{ #category : #default }
StStepIntoommand class >> defaultName [
	<toolbarDebugCommand: 20>
	
	^ 'Into'
]

{ #category : #initialization }
StStepIntoommand class >> defaultShortcut [
	^ PharoShortcuts current stepIntoShortcut
]

{ #category : #hooks }
StStepIntoommand >> execute [
	self debugger stepInto
]
