Class {
	#name : #PreDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
PreDebugCommand >> debugger [
	^self preDebugWindow debugger
]

{ #category : #accessing }
PreDebugCommand >> preDebugWindow [
	^ self context
]
