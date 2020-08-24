Class {
	#name : #DSDebuggerSelectionStrategyTest,
	#superclass : #TestCase,
	#category : #'Debuggers-SelectionStrategies-Tests'
}

{ #category : #'tests - debugging' }
DSDebuggerSelectionStrategyTest >> testHandled [
	self deny: DSDebuggerSelectionStrategy new handled
]
