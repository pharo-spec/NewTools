Class {
	#name : #StepOverDebugCommand,
	#superclass : #DebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StepOverDebugCommand class >> defaultDescription [
	^'Step over the highlighted message, i.e. do not follow the sent message, taking debugger control after the method invoked returns.'
]

{ #category : #initialization }
StepOverDebugCommand class >> defaultIconName [
	^ #glamorousOver
]

{ #category : #accessing }
StepOverDebugCommand class >> defaultName [
	<toolbarDebugCommand: 40>

	^ 'Over'
]

{ #category : #initialization }
StepOverDebugCommand class >> defaultShortcut [
	^ PharoShortcuts current stepOverShortcut
]

{ #category : #hooks }
StepOverDebugCommand >> execute [
	self session stepOver: self currentContext
]
