Extension { #name : #MessageNotUnderstood }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MessageNotUnderstood >> debug [
	"open a debugger on myself"

	(DebugRequest newForException: self) submit
]
