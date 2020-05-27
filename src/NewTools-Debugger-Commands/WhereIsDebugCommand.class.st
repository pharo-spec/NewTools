"
Requests the debugger to reselect in its code pane the next expression to be executed
"
Class {
	#name : #WhereIsDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
WhereIsDebugCommand class >> defaultDescription [
	^ 'Highligh the next method to be executed (step) by the debugger.'
]

{ #category : #initialization }
WhereIsDebugCommand class >> defaultIconName [
	^ #glamorousSearch 
]

{ #category : #default }
WhereIsDebugCommand class >> defaultName [
	<toolbarDebugCommand: 1000>
	^ 'Where is?'
]

{ #category : #initialization }
WhereIsDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
WhereIsDebugCommand >> execute [
	self debugger selectNextExecutedExpression
]
