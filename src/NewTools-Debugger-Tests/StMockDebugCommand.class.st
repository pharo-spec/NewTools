Class {
	#name : #StMockDebugCommand,
	#superclass : #StDebugCommand,
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #initialization }
StMockDebugCommand class >> defaultIconName [
	^ #defaultIconName
]

{ #category : #initialization }
StMockDebugCommand class >> defaultShortcut [
	^ #defaultShortcut
]

{ #category : #executing }
StMockDebugCommand >> execute [
	^self context
]
