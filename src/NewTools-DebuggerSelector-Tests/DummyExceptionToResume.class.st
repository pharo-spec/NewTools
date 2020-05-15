"
I am an exception to test DebuggerSelector #resumeException: behavior
"
Class {
	#name : #DummyExceptionToResume,
	#superclass : #Exception,
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #private }
DummyExceptionToResume >> defaultResumeValue [ 
	^#tag
]
