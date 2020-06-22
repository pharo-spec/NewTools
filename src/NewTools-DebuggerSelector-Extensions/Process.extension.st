Extension { #name : #Process }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Process >> debugException: anException [
	
	(DebugRequest newForException: anException) process: self; submit.
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Process >> debugWithTitle: title [
	"Open debugger on self"

	| context |
	context := self isActiveProcess
		ifTrue: [ thisContext ]
		ifFalse: [ self suspendedContext ].
	(DebugRequest newForContext: context) process: self; label: title; submit
]
