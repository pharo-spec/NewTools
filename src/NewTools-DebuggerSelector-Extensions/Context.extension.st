Extension { #name : #Context }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Context >> cannotReturn: result [
	closureOrNil
		ifNotNil: [ ^ BlockCannotReturn result: result from: self home ].
	NewDebuggerSelector
		debugProcess: Processor activeProcess
		fromContext: thisContext
		labeled: 'computation has been terminated'
]
