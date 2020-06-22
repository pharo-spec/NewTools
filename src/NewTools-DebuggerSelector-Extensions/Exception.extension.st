Extension { #name : #Exception }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> debug [
	"open a debugger on myself"

	(DebugRequest newForException: self) submit
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> isDebuggerFailure [
	^false
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> isHandleableBy: aDebugger [
	^ true
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Exception >> originException [
	^ self
]
