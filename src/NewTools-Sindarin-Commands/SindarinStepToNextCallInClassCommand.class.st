"
I will step the execution from a context until the next call to the same class as that context's receiver.
"
Class {
	#name : #SindarinStepToNextCallInClassCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #default }
SindarinStepToNextCallInClassCommand class >> defaultDescription [
	^ 'Steps execution until the next call in the current class, then returns debugger control.'
]

{ #category : #initialization }
SindarinStepToNextCallInClassCommand class >> defaultIconName [
	^ #glamorousInto
]

{ #category : #default }
SindarinStepToNextCallInClassCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ '[Exp.] Step until next call in class'
]

{ #category : #hooks }
SindarinStepToNextCallInClassCommand >> execute [

	| receiverClass debugger maxDepth depth |
	self context removeSessionHolderSubscriptions.
	debugger := self context sindarinDebugger.
	receiverClass := debugger context receiver class.
	debugger step.
	
	maxDepth := 50.
	depth := 0.
	[ 
	debugger context receiver class ~= receiverClass and: [ 
		depth < maxDepth ] ] whileTrue: [ 
		debugger step.
		depth := depth + 1 ].

	self context
		setSessionHolderSubscriptions;
		forceSessionUpdate
]
