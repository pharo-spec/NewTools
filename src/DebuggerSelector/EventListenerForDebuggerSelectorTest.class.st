Class {
	#name : #EventListenerForDebuggerSelectorTest,
	#superclass : #Object,
	#instVars : [
		'nbOfMainDebuggerClassUpdateEventReceived'
	],
	#category : #DebuggerSelector
}

{ #category : #initialization }
EventListenerForDebuggerSelectorTest >> initialize [
	super initialize.
	nbOfMainDebuggerClassUpdateEventReceived := 0
]

{ #category : #accessing }
EventListenerForDebuggerSelectorTest >> nbOfMainDebuggerClassUpdateEventReceived [
	^ nbOfMainDebuggerClassUpdateEventReceived
]

{ #category : #'react to events' }
EventListenerForDebuggerSelectorTest >> onMainDebuggerClassUpdate [
	nbOfMainDebuggerClassUpdateEventReceived := nbOfMainDebuggerClassUpdateEventReceived + 1
]
