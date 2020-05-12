Extension { #name : #SpecDebugger }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
SpecDebugger class >> debugSession: aDebugSession [
 	^self openOn: aDebugSession withFullView: true andNotification: nil
]
