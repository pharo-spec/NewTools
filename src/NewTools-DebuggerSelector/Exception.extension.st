Extension { #name : #Exception }

{ #category : #'*NewTools-DebuggerSelector' }
Exception >> debug: debuggerLevel [
	Processor activeProcess
		debug: self signalerContext
		level: debuggerLevel
		title: self description
		full: true
]
