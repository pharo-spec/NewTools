Class {
	#name : #StepTest,
	#superclass : #TestCase,
	#instVars : [
		'context',
		'session',
		'process'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #'as yet unclassified' }
StepTest >> currentContext [
	^ session interruptedContext.
]

{ #category : #'as yet unclassified' }
StepTest >> currentNode [
	^ session interruptedContext method sourceNodeForPC: session interruptedContext pc
]

{ #category : #running }
StepTest >> inspectCurrentNode: aDebugSession [
	context := aDebugSession interruptedContext.
	(context method sourceNodeForPC: context pc) inspect.
]

{ #category : #running }
StepTest >> setUp [
	super setUp.
	context := nil.
	process := nil.
	session := nil.
]

{ #category : #'as yet unclassified' }
StepTest >> settingUpSessionAndProcessAndContextForBlock: aBlock [
	context := aBlock asContext.
	process := Process 
	    forContext: context 
	    priority: Processor userInterruptPriority.
	session := DebugSessionPlus named: 'test session' on: process startedAt: context
]
