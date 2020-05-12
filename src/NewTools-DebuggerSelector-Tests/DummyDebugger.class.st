"
I am a dummy debugger.
My instances simulate debugger classes that are named, and can handle any context.
"
Class {
	#name : #DummyDebugger,
	#superclass : #Object,
	#instVars : [
		'name',
		'tag'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DummyDebugger class >> named: aString [
	^self new name: aString
]

{ #category : #'instance creation' }
DummyDebugger >> debugSession: aDebugSession [
	tag := aDebugSession
]

{ #category : #testing }
DummyDebugger >> handlesContext: aContext [
	^true
]

{ #category : #accessing }
DummyDebugger >> name [
	^ name
]

{ #category : #accessing }
DummyDebugger >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DummyDebugger >> tag [
	^ tag
]

{ #category : #accessing }
DummyDebugger >> tag: anObject [
	tag := anObject
]
