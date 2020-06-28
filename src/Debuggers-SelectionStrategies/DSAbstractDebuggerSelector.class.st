Class {
	#name : #DSAbstractDebuggerSelector,
	#superclass : #Object,
	#instVars : [
		'debuggers'
	],
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #instance }
DSAbstractDebuggerSelector class >> with: aCollection [
	^ self new
		debuggers: aCollection;
		yourself
]

{ #category : #accessing }
DSAbstractDebuggerSelector >> debuggers [
	^ debuggers
]

{ #category : #accessing }
DSAbstractDebuggerSelector >> debuggers: aCollection [ 
	debuggers := aCollection
]

{ #category : #iterating }
DSAbstractDebuggerSelector >> nextDebugger [
	^ self subclassResponsibility
]

{ #category : #debuggers }
DSAbstractDebuggerSelector >> openDebuggerForSession: aDebugSession [
	self subclassResponsibility 
]
