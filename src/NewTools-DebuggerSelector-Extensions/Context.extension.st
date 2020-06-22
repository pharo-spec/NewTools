Extension { #name : #Context }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Context >> cannotReturn: result [
	closureOrNil
		ifNotNil: [ ^ BlockCannotReturn result: result from: self home ].
	(DebugRequest newForContext: thisContext) label: 'computation has been terminated'; submit.
]
