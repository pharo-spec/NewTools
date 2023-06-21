Extension { #name : #StDebuggerActionModel }

{ #category : #'*NewTools-Debugger-Tests' }
StDebuggerActionModel >> hasUpdateEventListener: aDebugger [

	^ updateEventListeners includesKey: aDebugger
]
