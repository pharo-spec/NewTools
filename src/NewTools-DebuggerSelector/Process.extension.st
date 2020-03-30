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
