Extension { #name : #StDebugger }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
StDebugger class >> debugSession: aDebugSession [
 	^self openOn: aDebugSession withFullView: true andNotification: nil
]
