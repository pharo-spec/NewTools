Class {
	#name : #StHaltAndBreakpointControllerTest,
	#superclass : #StHaltAndBreakpointControlTest,
	#instVars : [
		'haltController',
		'testObject',
		'trace',
		'oldTracer'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #helper }
StHaltAndBreakpointControllerTest >> crTrace: aTextOrString [
	trace := aTextOrString 
]

{ #category : #running }
StHaltAndBreakpointControllerTest >> setUp [
	super setUp.
	testObject := StDummyTestClassWithHalts new.
	haltController := StHaltAndBreakpointController new.
	oldTracer := StHaltAndBreakpointController tracer.
	StHaltAndBreakpointController tracer: self
]

{ #category : #running }
StHaltAndBreakpointControllerTest >> tearDown [
	super tearDown.
	trace := nil.
	StHaltAndBreakpointController tracer: oldTracer
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisableBreakpoint [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisableHalt [
	
	self should: [ testObject mHalt ] raise: Halt.	
	haltController disableHaltOrBreakpointFor: (cache nodeCacheForSelector: #mHalt) first.
	self shouldnt: [ testObject mHalt ] raise: Halt
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisabledBreakpointisDisabled [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisabledHaltIsDisabled [
	| node |
	node := (cache nodeCacheForSelector: #mHalt) first.
	haltController disableHaltOrBreakpointFor: node.
	self deny: (haltController areHaltsAndBreakpoinsEnabledFor: node)
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnableDisabledBreakpoint [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnableDisabledHalt [
	|node|
	node := (cache nodeCacheForSelector: #mHalt) first.
	haltController disableHaltOrBreakpointFor: node.
	self shouldnt: [ testObject mHalt ] raise: Halt.
	haltController enableHaltOrBreakpointFor: node.
	self should: [ testObject mHalt ] raise: Halt
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnabledBreakpointIsEnabled [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnabledHaltIsEnabled [
	| node |
	node := (cache nodeCacheForSelector: #mHalt) first.
	self assert: (haltController areHaltsAndBreakpoinsEnabledFor: node)
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testNoTraceForEnabledHalt [
	[ testObject mHalt ]
		on: Halt
		do: [ :e | e resume ].
	self assert: trace isNil
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testTraceForDisabledHalt [
	| node |
	node := (cache nodeCacheForSelector: #mHalt) first.
	haltController disableHaltOrBreakpointFor: node.
	testObject mHalt.
	self
		assert: trace
		equals: (StHaltAndBreakpointController printSkipTextFor: node)
]
