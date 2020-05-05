Extension { #name : #DebugSession }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
DebugSession >> exception [
	^ exception
		ifNil: [ exception := DebuggerSelectorNullException
				fromSignallerContext: self interruptedContext ]
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
DebugSession >> exception: anObject [
	exception := anObject
]
