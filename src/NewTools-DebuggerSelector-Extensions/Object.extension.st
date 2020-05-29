Extension { #name : #Object }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Object >> defaultDebugSessionRank [
	^-1
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
Object class >> handlesContext: aContext [
	"Whether I'm a competent debugger for aContext"
	^ false
]
