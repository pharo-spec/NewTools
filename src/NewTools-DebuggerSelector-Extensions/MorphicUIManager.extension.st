Extension { #name : #MorphicUIManager }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> debugProcess: process level: debuggerLevel context: context label: title fullView: bool notification: notificationString [
	OldDebuggerSelector singleton
		debugProcess: process
		level: debuggerLevel
		context: context
		label: title
		fullView: bool
		notification: notificationString
		fromUIManager: self
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> handleError: anError log: shouldLog [
	shouldLog
		ifTrue: [ self logError: anError ].
	DebuggerSelector
		debugException: anError
		inProcess: Processor activeProcess
		from: self
]
