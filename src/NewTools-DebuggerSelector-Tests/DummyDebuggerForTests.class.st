Class {
	#name : #DummyDebuggerForTests,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DummyDebuggerForTests class >> named: aString [
	^self new name: aString
]

{ #category : #testing }
DummyDebuggerForTests >> handlesContext: aContext [
	^true
]

{ #category : #accessing }
DummyDebuggerForTests >> name [
	^ name
]

{ #category : #accessing }
DummyDebuggerForTests >> name: anObject [
	name := anObject
]
