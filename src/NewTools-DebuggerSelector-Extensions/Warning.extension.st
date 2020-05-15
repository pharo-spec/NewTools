Extension { #name : #Warning }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Warning >> unhandledErrorAction [
	"No one has handled this warning, then I gave them a chance to decide how to debug it and I raise an UnhandledError. But it was not handled by anybody so that we are here (see UnhandedError-defaultAction).
	It is the final action an exception can do which is normally a debugger in interactive image"

	^ DebuggerSelector debuggerWarning: self from: UIManager default
]
