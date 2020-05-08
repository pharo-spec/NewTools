Extension { #name : #DebugSession }

{ #category : #'*Emergency-Debugger' }
DebugSession >> signalDebuggerError: anError [
	EDEmergencyDebuggerSettings defaultEmergencyDebugger
		debugError: anError
		fromSession: self
]
