Class {
	#name : #DSDebuggerSelector,
	#superclass : #DSAbstractDebuggerSelector,
	#instVars : [
		'debuggers'
	],
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #instance }
DSDebuggerSelector class >> with: aCollection [
	^ self new
		debuggers: aCollection;
		yourself
]

{ #category : #accessing }
DSDebuggerSelector >> debuggers [
	^ debuggers
]

{ #category : #accessing }
DSDebuggerSelector >> debuggers: aCollection [
	debuggers := Stack newFrom: aCollection
]

{ #category : #iterating }
DSDebuggerSelector >> nextDebugger [
	debuggers isEmpty
		ifTrue: [ ^ Transcripter ].
	^ debuggers pop
]
