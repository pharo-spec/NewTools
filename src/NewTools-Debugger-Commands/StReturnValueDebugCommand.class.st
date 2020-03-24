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

{ #category : #actions }
StReturnValueDebugCommand >> execute [
	self debugger returnEnteredValue
]
