Extension { #name : #Process }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Process >> debug: context level: debuggerLevel title: title full: bool [
	^ UIManager default
		debugProcess: self
		level: debuggerLevel
		context: context
		label: title
		fullView: bool
		notification: nil
]

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
	self flag: #TESTME.
	context := self isActiveProcess
		ifTrue: [ thisContext ]
		ifFalse: [ self suspendedContext ].
	^ DebuggerSelector
		debugProcess: self
		fromContext: context
		labeled: title
]
