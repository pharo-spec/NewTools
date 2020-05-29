"
A mock command for dezbugger command tree builder tests
"
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
StMockDebugCommand class >> defaultName [
	^ Time now asNanoSeconds printString
]

{ #category : #initialization }
StMockDebugCommand class >> defaultShortcut [
	^ #defaultShortcut
]

{ #category : #executing }
StMockDebugCommand >> execute [
	^self context
]
