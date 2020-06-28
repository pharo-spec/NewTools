"
I am a dummy debugger.
My instances simulate debugger classes that are named, and can handle any context.
"
Class {
	#name : #DSDummyDebugger,
	#superclass : #Object,
	#instVars : [
		'name',
		'tag',
		'deferred',
		'usable'
	],
	#category : #'Debuggers-SelectionStrategies-Tests'
}

{ #category : #'instance creation' }
DSDummyDebugger class >> named: aString [
	^self new name: aString
]

{ #category : #accessing }
DSDummyDebugger >> beUnusable [
	usable := false
]

{ #category : #'instance creation' }
DSDummyDebugger >> debugSession: aDebugSession [
	tag := aDebugSession
	
]

{ #category : #'deferred message' }
DSDummyDebugger >> defer: aBlock [
	aBlock value.
	deferred := true 
]

{ #category : #accessing }
DSDummyDebugger >> deferred [
	^ deferred ifNil:[deferred := false]
]

{ #category : #testing }
DSDummyDebugger >> handlesContext: aContext [
	^usable ifNil:[true]
]

{ #category : #helpers }
DSDummyDebugger >> methodToDebug [
	| i |
	i := 0.
	10 timesRepeat: [ i := i + 1 ].
	^ i
]

{ #category : #accessing }
DSDummyDebugger >> name [
	^ name
]

{ #category : #accessing }
DSDummyDebugger >> name: anObject [
	name := anObject
]

{ #category : #debugging }
DSDummyDebugger >> signalDebuggerError: exception [
	(DebuggerFailure of: self on: exception) signal
]

{ #category : #accessing }
DSDummyDebugger >> tag [
	^ tag
]

{ #category : #accessing }
DSDummyDebugger >> tag: anObject [
	tag := anObject
]

{ #category : #'ui requests' }
DSDummyDebugger >> warningDefaultAction: aWarningException [
	tag := aWarningException
]

{ #category : #helpers }
DSDummyDebugger >> zeroDivide [
	1/0
]
