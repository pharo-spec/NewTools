Class {
	#name : #PreDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #accessing }
PreDebugCommand >> debugger [
	^self preDebugWindow debugger
]

{ #category : #accessing }
PreDebugCommand >> preDebugWindow [
	^ self context
]
