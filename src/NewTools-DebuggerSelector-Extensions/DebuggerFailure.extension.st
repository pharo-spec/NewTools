Extension { #name : #DebuggerFailure }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
DebuggerFailure >> debug [
	"open a debugger on myself"

	DebuggerSelector
		debugException: self
		inProcess: Processor activeProcess
		from: UIManager default
]
