Extension { #name : #MorphicUIManager }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> handleError: anError log: shouldLog [
	shouldLog
		ifTrue: [ self logError: anError ].
	DebuggerSelector
		debugException: anError
		inProcess: Processor activeProcess
		from: self
]
