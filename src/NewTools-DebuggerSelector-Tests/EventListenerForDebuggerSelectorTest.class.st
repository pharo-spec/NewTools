Class {
	#name : 'EventListenerForDebuggerSelectorTest',
	#superclass : 'Object',
	#instVars : [
		'nbOfMainDebuggerClassUpdateEventReceived'
	],
	#category : 'NewTools-DebuggerSelector-Tests',
	#package : 'NewTools-DebuggerSelector-Tests'
}

{ #category : 'initialization' }
EventListenerForDebuggerSelectorTest >> initialize [
	super initialize.
	nbOfMainDebuggerClassUpdateEventReceived := 0
]

{ #category : 'accessing' }
EventListenerForDebuggerSelectorTest >> nbOfMainDebuggerClassUpdateEventReceived [
	^ nbOfMainDebuggerClassUpdateEventReceived
]

{ #category : 'react to events' }
EventListenerForDebuggerSelectorTest >> onMainDebuggerClassUpdate [
	nbOfMainDebuggerClassUpdateEventReceived := nbOfMainDebuggerClassUpdateEventReceived + 1
]
