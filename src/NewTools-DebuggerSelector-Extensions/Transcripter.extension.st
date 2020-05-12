Extension { #name : #Transcripter }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Transcripter class >> debugSession: aDebugSession [
	aDebugSession signalDebuggerError: aDebugSession exception
]
