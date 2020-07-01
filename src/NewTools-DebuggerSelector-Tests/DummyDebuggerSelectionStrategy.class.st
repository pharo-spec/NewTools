"
I am a dummy debugger selection strategy, used for testing
"
Class {
	#name : #DummyDebuggerSelectionStrategy,
	#superclass : #DSDebuggerSelectionStrategy,
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #iterating }
DummyDebuggerSelectionStrategy >> nextDebugger [
	"This method is not used in the tests, but is defined as a subclass responsibility by DSDebuggerSelectionStrategy"
	self error: 'Should not be called'
]

{ #category : #'instance creation' }
DummyDebuggerSelectionStrategy >> openDebuggerForSession: aDebugSession [
	"Do nothing, to avoid opening a debugger during tests"
	^ 1
]
