Extension { #name : #MorphicUIManager }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> handleDebugRequest: aDebugRequest [

	DebuggerSystem openDebuggerOnRequest: aDebugRequest
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> handleError: anError log: shouldLog [
	shouldLog
		ifTrue: [ self logError: anError ].
	(DebugRequest newForException: self) uiManager: self; submit.
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> handleWarningDebugRequest: aWarningDebugRequest [

	DebuggerSystem openDebuggerOnRequest: aWarningDebugRequest
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
MorphicUIManager >> warningDefaultAction: anException [
	"The user should be notified of the occurrence of an exceptional occurrence and given an option of continuing or aborting the computation. The description of the occurrence should include any text specified as the argument of the #signal: message."

	(WarningDebugRequest newForException: anException) submit.
]
