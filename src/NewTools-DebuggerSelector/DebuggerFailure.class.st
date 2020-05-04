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
DebuggerFailure >> isHandleableBy: aDebugger [
(FileSystem workingDirectory / 'test' ) writeStream
	nextPutAll: ((FileSystem workingDirectory / 'test' ) readStream contents);
	nextPutAll: aDebugger name; space; nextPutAll: self class name; cr; close.
	
	aDebugger = GTGenericStackDebugger ifTrue: [ ^ true ].
	^ aDebugger ~= failedDebugger
		and: [ innerException isHandleableBy: aDebugger ]
]

{ #category : #testing }
DebuggerFailure >> originException [
	^ innerException originException
]

{ #category : #accessing }
DebuggerFailure >> signalerContext [
	^ self originException signalerContext
]
