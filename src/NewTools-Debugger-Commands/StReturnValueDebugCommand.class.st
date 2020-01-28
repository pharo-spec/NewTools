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
	<StackContextMenuDebugCommand>
	
	^ 'Return entered value'
]

{ #category : #initialization }
StReturnValueDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #actions }
StReturnValueDebugCommand >> execute [
	|expression value|
	self flag: 'Move this behavior to debugger'.
	
	expression := UIManager default request: 'Enter expression for return value:'.
	value := self class compiler
			source: expression;
			context: self currentContext;
			receiver: self currentContext receiver;
			evaluate.

	self session returnValue: value from: self currentContext
]
