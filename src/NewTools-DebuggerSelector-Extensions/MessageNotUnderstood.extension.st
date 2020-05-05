Extension { #name : #MessageNotUnderstood }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MessageNotUnderstood >> debug [
	"open a debugger on myself"

	NewDebuggerSelector
		debugException: self
		inProcess: Processor activeProcess
		from: UIManager default
]
