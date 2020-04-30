Extension { #name : #Exception }

{ #category : #'*NewTools-DebuggerSelector' }
Exception >> debug: debuggerLevel [
	self flag: 'Bad selector choice, confusing with other #debug: messages'.
	Processor activeProcess
		debug: self signalerContext
		level: debuggerLevel
		title: self description
		full: true
]

{ #category : #'*NewTools-DebuggerSelector' }
Exception >> isHandlableBy: aDebugger [
	^ true
]

{ #category : #'*NewTools-DebuggerSelector' }
Exception >> originException [
	^ self
]
