"
I am a debugger selector with a static list of debuggers for test purposes
"
Class {
	#name : #DummyDebuggerSelector,
	#superclass : #DebuggerSelector,
	#classVars : [
		'staticDebuggers'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #initialization }
DummyDebuggerSelector class >> debuggers: debuggers [
	staticDebuggers := debuggers
]

{ #category : #'instance creation' }
DummyDebuggerSelector class >> newDebuggerSelector [
	^ self with: staticDebuggers
]
