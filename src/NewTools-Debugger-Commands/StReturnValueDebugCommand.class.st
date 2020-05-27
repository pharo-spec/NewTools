"
Requests the debugger to return from the current context with the result of the evaluation of a user-defined expression.
"
Class {
	#name : #StReturnValueDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
StReturnValueDebugCommand class >> defaultDescription [
	^ 'Return of a given value to the previous context.'
]

{ #category : #initialization }
StReturnValueDebugCommand class >> defaultIconName [
	^ #refresh
]

{ #category : #accessing }
StReturnValueDebugCommand class >> defaultLabel [

	^ 'Return entered value'
]

{ #category : #accessing }
StReturnValueDebugCommand class >> defaultName [
	<toolbarDebugCommand: 910>
	^ 'Return'
]

{ #category : #initialization }
StReturnValueDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #accessing }
StReturnValueDebugCommand >> canBeExecuted [
	"I can always return from a context, for ex. if I'm stuck because of a DNU."
	^ true
]

{ #category : #actions }
StReturnValueDebugCommand >> execute [
	self debugger returnEnteredValue
]
