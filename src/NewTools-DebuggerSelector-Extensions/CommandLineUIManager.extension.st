Extension { #name : #CommandLineUIManager }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
CommandLineUIManager >> handleDebugRequest: aDebugRequest [
	
	self unhandledErrorDefaultAction: aDebugRequest exception
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
CommandLineUIManager >> handleWarningDebugRequest: aWarningDebugRequest [
	
	self warningDefaultAction: aWarningDebugRequest exception
]
