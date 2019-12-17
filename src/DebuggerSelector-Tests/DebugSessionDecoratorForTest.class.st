Class {
	#name : #DebugSessionDecoratorForTest,
	#superclass : #Object,
	#instVars : [
		'nbOfTimesTerminateWasCalled',
		'decoratedDebugSession'
	],
	#category : #'DebuggerSelector-Tests'
}

{ #category : #'instance creation' }
DebugSessionDecoratorForTest class >> newOn: aDebugSession [
	| newInstance |
	newInstance := self new.
	newInstance decoratedDebugSession: aDebugSession.
	^ newInstance
]

{ #category : #accessing }
DebugSessionDecoratorForTest >> decoratedDebugSession: aDebugSession [
	decoratedDebugSession := aDebugSession
]

{ #category : #decorator }
DebugSessionDecoratorForTest >> doesNotUnderstand: aMessage [
	aMessage lookupClass: decoratedDebugSession class.
	^ aMessage sentTo: decoratedDebugSession
]

{ #category : #initialization }
DebugSessionDecoratorForTest >> initialize [
	super initialize.
	nbOfTimesTerminateWasCalled := 0
]

{ #category : #accessing }
DebugSessionDecoratorForTest >> nbOfTimesTerminateWasCalled [
	^ nbOfTimesTerminateWasCalled
]

{ #category : #decorator }
DebugSessionDecoratorForTest >> terminate [
	nbOfTimesTerminateWasCalled := nbOfTimesTerminateWasCalled + 1.
	^ decoratedDebugSession terminate
]
