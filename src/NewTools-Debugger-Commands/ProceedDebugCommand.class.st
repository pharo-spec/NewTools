"
Request the debugger to proceed the debug session
"
Class {
	#name : #ProceedDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
ProceedDebugCommand class >> defaultDescription [
	^ 'Relinquish debugger control and proceed execution from the current point of debugger control.'
]

{ #category : #initialization }
ProceedDebugCommand class >> defaultIconName [
	^ #glamorousGo
]

{ #category : #default }
ProceedDebugCommand class >> defaultName [
	<toolbarDebugCommand: 10>
	^ 'Proceed'
]

{ #category : #initialization }
ProceedDebugCommand class >> defaultShortcut [
	^ PharoShortcuts current resumeExecutionShortcut
]

{ #category : #hooks }
ProceedDebugCommand >> execute [
	self debugger proceedDebugSession
]
