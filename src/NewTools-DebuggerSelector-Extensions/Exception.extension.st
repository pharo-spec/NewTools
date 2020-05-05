Extension { #name : #Exception }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> debug: debuggerLevel [
	self flag: 'Bad selector choice, confusing with other #debug: messages'.
	Processor activeProcess
		debug: self signalerContext
		level: debuggerLevel
		title: self description
		full: true
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> isHandleableBy: aDebugger [
	^ true
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> originException [
	^ self
]
