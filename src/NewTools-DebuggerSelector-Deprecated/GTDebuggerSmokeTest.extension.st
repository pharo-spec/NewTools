Extension { #name : #GTDebuggerSmokeTest }

{ #category : #'*NewTools-DebuggerSelector-Deprecated' }
GTDebuggerSmokeTest >> assertDebuggerClosing [
	
 	debugger close.

	self assert: window model equals: nil.
	"The following two lines are no longer relevant since debuggers are no longer supposed to kill their debug session themselves because DebugSessionStorage does it"
	"self assert: debugger session interruptedContext equals: nil.
	self assert: debugger session interruptedProcess equals: nil."
	"Instead, they are supposed to have released it"
]
