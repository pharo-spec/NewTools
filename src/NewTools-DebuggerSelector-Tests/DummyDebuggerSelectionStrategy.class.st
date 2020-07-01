"
I am a dummy debugger selection strategy, used for testing
"
Class {
	#name : #DummyDebuggerSelectionStrategy,
	#superclass : #'DebuggerSelector_',
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DummyDebuggerSelectionStrategy >> openDebuggerForSession: aDebugSession [
	"Do nothing, to avoid opening a debugger during tests"
	^ 1
]
