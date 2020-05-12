Extension { #name : #GTMoldableDebugger }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
GTMoldableDebugger class >> debugSession: aDebugSession [
	
	self openOn: aDebugSession withFullView: true andNotification: nil
]
