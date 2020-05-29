Extension { #name : #Exception }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> debug [
	"open a debugger on myself"

	DebuggerSelector
		debugException: self
		inProcess: Processor activeProcess
		from: UIManager default
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> isHandleableBy: aDebugger [
	^ true
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> originException [
	^ self
]
