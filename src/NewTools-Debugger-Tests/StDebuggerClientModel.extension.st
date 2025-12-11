Extension { #name : 'StDebuggerClientModel' }

{ #category : '*NewTools-Debugger-Tests' }
StDebuggerClientModel >> hasSubscriber: aDebugger [

	^ self announcer hasSubscriber: aDebugger
]
