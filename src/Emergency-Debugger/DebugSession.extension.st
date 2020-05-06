Extension { #name : #DebugSession }

{ #category : #'*Emergency-Debugger' }
DebugSession >> signalDebuggerError: anError [
	EDEmergencyDebugger debug: self
]
