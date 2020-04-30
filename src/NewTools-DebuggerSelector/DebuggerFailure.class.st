Class {
	#name : #DebuggerFailure,
	#superclass : #Exception,
	#instVars : [
		'failedDebugger',
		'innerException'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #'instance creation' }
DebuggerFailure class >> of: aDebugger on: anException [
	^ self new
		debugger: aDebugger exception: anException;
		yourself
]

{ #category : #handling }
DebuggerFailure >> debug [
	"open a debugger on myself"
	
	Processor activeProcess 
		debug: self signalerContext
		title: self description
]

{ #category : #initialization }
DebuggerFailure >> debugger: aDebugger exception: anException [
	failedDebugger := aDebugger.
	innerException := anException
]

{ #category : #testing }
DebuggerFailure >> isHandlableBy: aDebugger [
	^ aDebugger ~= failedDebugger
		and: [ innerException isHandlableBy: aDebugger ]
]

{ #category : #testing }
DebuggerFailure >> originException [
	^ innerException originException
]
