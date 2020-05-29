Extension { #name : #Process }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Process >> debugException: anException [
	DebuggerSelector
		debugException: anException
		inProcess: self
		from: UIManager default
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Process >> debugWithTitle: title [
	"Open debugger on self"

	| context |
	context := self isActiveProcess
		ifTrue: [ thisContext ]
		ifFalse: [ self suspendedContext ].
	^ DebuggerSelector
		debugProcess: self
		fromContext: context
		labeled: title
]
