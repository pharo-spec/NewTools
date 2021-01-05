"
I will step the execution until a class is instantiated
"
Class {
	#name : #SindarinStepToNextInstanceCreation,
	#superclass : #SindarinCommand,
	#instVars : [
		'debugger',
		'conditionValue'
	],
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #initialization }
SindarinStepToNextInstanceCreation class >> defaultIconName [
	^ #smallNew
]

{ #category : #default }
SindarinStepToNextInstanceCreation class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'Next instance creation'
]

{ #category : #hooks }
SindarinStepToNextInstanceCreation >> execute [

	| sender maxDepth depth |
	self context removeSessionHolderSubscriptions.
	debugger := self context sindarinDebugger.
	sender := debugger context sender.

	maxDepth := 1000.
	depth := 0.
	[ 
	(debugger node isMessage and: [ 
		 #( new basicNew new: basicNew:) includes: debugger node selector ]) or: [ 
		depth >= maxDepth ] ] whileFalse: [ 
		debugger step.
		depth := depth + 1.
		debugger context == sender ifTrue: [ depth := 1000 ].
		debugger hasSignalledUnhandledException ifTrue: [ depth := 1000 ] ].

	self context
		setSessionHolderSubscriptions;
		forceSessionUpdate
]
