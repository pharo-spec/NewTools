"
I am a dummy debugger selection strategy, used for testing
"
Class {
	#name : #DummyDebuggerSelectionStrategy,
	#superclass : #'DebuggerSelector_',
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DummyDebuggerSelectionStrategy >> openOn: aDebugSession [
	^ 1
]
