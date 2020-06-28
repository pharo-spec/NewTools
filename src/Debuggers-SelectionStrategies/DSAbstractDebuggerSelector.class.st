Class {
	#name : #DSAbstractDebuggerSelector,
	#superclass : #Object,
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #iterating }
DSAbstractDebuggerSelector >> nextDebugger [
	^ self subclassResponsibility
]
