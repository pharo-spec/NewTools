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
	NewDebuggerSelector
		debugException: anException
		inProcess: self
		from: UIManager default
]
