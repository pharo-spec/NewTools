Extension { #name : #Object }

{ #category : #'*NewTools-DebuggerSelector' }
Object >> defaultDebugSessionRank [
	^-1
]

{ #category : #'*NewTools-DebuggerSelector' }
Object class >> handlesContext: aContext [
	"Whether I'm a competent debugger for aContext"
	^ false
]

{ #category : #'*NewTools-DebuggerSelector' }
Object >> rankDebugSession: aDebugSession [
	^self defaultDebugSessionRank
]
