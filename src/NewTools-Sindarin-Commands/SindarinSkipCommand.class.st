Class {
	#name : #SindarinSkipCommand,
	#superclass : #SindarinSkipAllToSelectionCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinSkipCommand class >> defaultDescription [
	^ 'Skips execution of the next step, then returns debugger control.'
]

{ #category : #'accessing - defaults' }
SindarinSkipCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 1>
	<codeExtensionDebugCommand: 1>
	^ 'Skip'
]

{ #category : #hooks }
SindarinSkipCommand >> execute [

	| targetNode |
	self flag:
		'Context should actually be a debugger or a sindarin debugger'.
	self context sindarinDebugger skip.
	self context forceSessionUpdate
]
