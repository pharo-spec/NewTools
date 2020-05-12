"
I am a dummy debugger.
My instances simulate debugger classes that are named, and cannot handle any context.
"
Class {
	#name : #DummyUnusableDebugger,
	#superclass : #DummyDebugger,
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DummyUnusableDebugger >> debugSession: aDebugSession [
	tag := Error new.
	tag signalIn: thisContext.
	tag signal
]

{ #category : #testing }
DummyUnusableDebugger >> handlesContext: aContext [
	^false
]
