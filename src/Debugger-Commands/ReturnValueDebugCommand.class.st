Class {
	#name : #ReturnValueDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
ReturnValueDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 910>
	
	^ 'Return'
]

{ #category : #accessing }
ReturnValueDebugCommand class >> defaultDescription [
	^ 'Return of a given value to the previous context.'
]

{ #category : #initialization }
ReturnValueDebugCommand class >> defaultIconName [
	^ #refresh
]

{ #category : #accessing }
ReturnValueDebugCommand class >> defaultLabel [

	^ 'Return entered value'
]

{ #category : #accessing }
ReturnValueDebugCommand class >> defaultName [
	
	^ 'Return'
]

{ #category : #initialization }
ReturnValueDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
ReturnValueDebugCommand >> execute [
	|expression value|
	
	expression := UIManager default request: 'Enter expression for return value:'.
	value := self class compiler
			source: expression;
			context: self currentContext;
			receiver: self currentContext receiver;
			evaluate.

	self session returnValue: value from: self currentContext
]
