Extension { #name : #MessageNotUnderstood }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MessageNotUnderstood >> debug [
	"open a debugger on myself"

	DebuggerSelector
		debugException: self
		inProcess: Processor activeProcess
		from: UIManager default
]
