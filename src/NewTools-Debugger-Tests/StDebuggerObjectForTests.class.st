"
I am a dummy object to test StDebuggerContext inspector nodes building.
"
Class {
	#name : #StDebuggerObjectForTests,
	#superclass : #Object,
	#instVars : [
		'instVar'
	],
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #initialization }
StDebuggerObjectForTests >> initialize [ 
	instVar := 0
]

{ #category : #accessing }
StDebuggerObjectForTests >> instVar [
	^ instVar
]

{ #category : #util }
StDebuggerObjectForTests >> methodWithArg1: a arg2: b [	
	^a + b
]

{ #category : #util }
StDebuggerObjectForTests >> methodWithTemps [
	|a b|
	a := 0.
	b := 0.
	^a + b
]
