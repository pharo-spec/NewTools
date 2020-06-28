Class {
	#name : #DSDebuggerSelectionStrategy,
	#superclass : #Object,
	#instVars : [
		'debuggers'
	],
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #instance }
DSDebuggerSelectionStrategy class >> with: aCollection [
	^ self new
		debuggers: aCollection;
		yourself
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> debuggers [
	^ debuggers
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> debuggers: aCollection [ 
	debuggers := aCollection
]

{ #category : #iterating }
DSDebuggerSelectionStrategy >> nextDebugger [
	^ self subclassResponsibility
]

{ #category : #debuggers }
DSDebuggerSelectionStrategy >> openDebuggerForSession: aDebugSession [
	self subclassResponsibility 
]
