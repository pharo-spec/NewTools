Extension { #name : #Process }

{ #category : #'*NewTools-DebuggerSelector' }
Process >> debug: context level: debuggerLevel title: title full: bool [
	^ UIManager default
		debugProcess: self
		level: debuggerLevel
		context: context
		label: title
		fullView: bool
		notification: nil
]

{ #category : #'*NewTools-DebuggerSelector' }
Process >> debugException: anException [
	NewDebuggerSelector
		debugException: anException
		inProcess: self
		from: UIManager default
]
