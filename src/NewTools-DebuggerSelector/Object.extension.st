Extension { #name : #Object }

{ #category : #'*NewTools-DebuggerSelector' }
Object >> defaultDebugSessionRank [
	^-1
]

{ #category : #'*NewTools-DebuggerSelector' }
Object >> rankDebugSession: aDebugSession [
	^self defaultDebugSessionRank
]
