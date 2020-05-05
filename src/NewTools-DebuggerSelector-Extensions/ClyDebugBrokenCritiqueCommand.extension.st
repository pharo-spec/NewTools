Extension { #name : #ClyDebugBrokenCritiqueCommand }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
ClyDebugBrokenCritiqueCommand >> execute [
	NewDebuggerSelector
		debugProcess: Processor activeProcess
		fromContext: critique stack
		labeled: critique message
]
