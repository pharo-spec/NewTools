Extension { #name : 'StDebuggerActionModel' }

{ #category : '*NewTools-Debugger-Tests' }
StDebuggerActionModel >> hasSubscriber: aDebugger [

	^ self announcer hasSubscriber: aDebugger
]
