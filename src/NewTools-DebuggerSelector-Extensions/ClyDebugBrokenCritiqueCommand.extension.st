Extension { #name : #ClyDebugBrokenCritiqueCommand }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
ClyDebugBrokenCritiqueCommand >> execute [
	DebuggerSelector
		debugProcess: Processor activeProcess
		fromContext: critique stack
		labeled: critique message
]
