"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : #StDebuggerActionModel,
	#superclass : #Object,
	#instVars : [
		'debugger'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerActionModel class >> on: aStDebugger [
	^ self new debugger: aStDebugger
]

{ #category : #accessing }
StDebuggerActionModel >> currentContext [
	^ self debugger currentContext
]

{ #category : #accessing }
StDebuggerActionModel >> debugger [
	^ debugger
]

{ #category : #accessing }
StDebuggerActionModel >> debugger: anObject [
	debugger := anObject
]

{ #category : #accessing }
StDebuggerActionModel >> interruptedContext [
	^self session interruptedContext
]

{ #category : #accessing }
StDebuggerActionModel >> session [
	^self debugger session
]
