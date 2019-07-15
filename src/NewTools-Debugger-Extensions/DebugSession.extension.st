Extension { #name : #DebugSession }

{ #category : #'*NewTools-Debugger-Extensions' }
DebugSession >> shortStack [
	^self stackOfSize: self shortStackSize
]

{ #category : #'*NewTools-Debugger-Extensions' }
DebugSession >> shortStackSize [
	^ 20
]
