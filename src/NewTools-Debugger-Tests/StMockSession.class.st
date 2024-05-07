"
I'm an object answering to part of the API of `DebugSession`, but doing nothing.
You can use me in your tests where messages are sent to a debug session but you do not actually want to act on a real one. 
"
Class {
	#name : 'StMockSession',
	#superclass : 'Object',
	#instVars : [
		'dummyContext'
	],
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'reflective operations' }
StMockSession >> doesNotUnderstand: aMessage [

	^ self
]

{ #category : 'accessing' }
StMockSession >> dummyContext: anObject [

	dummyContext := anObject
]

{ #category : 'debug - session' }
StMockSession >> implement: aMessage inClass: aClass forContext: aContext [
]

{ #category : 'accessing' }
StMockSession >> interruptedContext [
	 ^dummyContext ifNil:[self]
]

{ #category : 'debugging actions' }
StMockSession >> restart: aContext [
]

{ #category : 'debugging actions' }
StMockSession >> returnValue: value from: aContext [
]

{ #category : 'debugging actions' }
StMockSession >> runToSelection: aSelectionInterval inContext: aContext [
]

{ #category : 'accessing' }
StMockSession >> scope [
]

{ #category : 'accessing' }
StMockSession >> sourceNodeExecuted [
]

{ #category : 'debugging actions' }
StMockSession >> stepInto: aContext [ 
]

{ #category : 'debugging actions' }
StMockSession >> stepOver: aContext [
]

{ #category : 'debugging actions' }
StMockSession >> stepThrough: aContext [
]

{ #category : 'as yet unclassified' }
StMockSession >> subclassResponsibilityExample [
	^self subclassResponsibility 
]
