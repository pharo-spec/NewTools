Class {
	#name : #StHaltAndBreakpointControllerTest,
	#superclass : #StHaltAndBreakpointControlTest,
	#instVars : [
		'haltController',
		'testObject',
		'trace',
		'oldTracer',
		'breakpoint'
	],
	#category : #'NewTools-Debugger-Breakpoints-Tools-Tests'
}

{ #category : #helper }
StHaltAndBreakpointControllerTest >> crTrace: aTextOrString [
	trace := aTextOrString 
]

{ #category : #helper }
StHaltAndBreakpointControllerTest >> installBreakpointOn: aNode [
	^ Breakpoint new
		node: aNode;
		install;
		yourself
]

{ #category : #helper }
StHaltAndBreakpointControllerTest >> node [
	^ (cache nodeCacheForSelector: 'StDummyTestClassWithHalts>>#mHalt') first 
]

{ #category : #helper }
StHaltAndBreakpointControllerTest >> nodeForBreakpoint [
	^ (StDummyTestClassWithHalts >> #mNoHalt) ast statements first
]

{ #category : #running }
StHaltAndBreakpointControllerTest >> setUp [
	super setUp.
	testObject := StDummyTestClassWithHalts new.
	haltController := StHaltAndBreakpointController new.
	oldTracer := StHaltAndBreakpointController tracer.
	StHaltAndBreakpointController tracer: self.
	breakpoint := self installBreakpointOn: self nodeForBreakpoint
]

{ #category : #running }
StHaltAndBreakpointControllerTest >> tearDown [
	trace := nil.
	StHaltAndBreakpointController tracer: oldTracer.
	breakpoint ifNotNil: [ breakpoint remove ].
	super tearDown
]

{ #category : #'tests - breakpoints' }
StHaltAndBreakpointControllerTest >> testDisableBreakpoint [
	<ignoreNotImplementedSelectors: #(mNoHalt)>
	self should: [ testObject mNoHalt ] raise: Break.
	haltController disableBreakpoint: breakpoint.
	self shouldnt: [ testObject mNoHalt ] raise: Break
	
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testDisableHalt [
	<ignoreNotImplementedSelectors: #(mHalt)>
	self should: [ testObject mHalt ] raise: Halt.	
	haltController disableHaltNode: self node.
	self shouldnt: [ testObject mHalt ] raise: Halt
]

{ #category : #'tests - breakpoints' }
StHaltAndBreakpointControllerTest >> testDisabledBreakpointisDisabled [

	haltController disableBreakpoint: breakpoint.
	self deny: (haltController isBreakpointEnabled: breakpoint).
	self deny: (haltController isHaltOrBreakpointEnabled:
			 (StBreakpointInspectionItem forBreakpoint: breakpoint))
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testDisabledHaltIsDisabled [

	haltController disableHaltNode: self node.
	self deny: (haltController isHaltEnabledFor: self node).
	self deny: (haltController isHaltOrBreakpointEnabled:
			 (StHaltInspectionItem forHalt: self node))
]

{ #category : #'tests - breakpoints' }
StHaltAndBreakpointControllerTest >> testEnableDisabledBreakpoint [
	<ignoreNotImplementedSelectors: #(mNoHalt)>
	haltController disableBreakpoint: breakpoint.
	self shouldnt: [ testObject mNoHalt ] raise: Break.
	haltController enableBreakpoint: breakpoint.
	self should: [ testObject mNoHalt ] raise: Break
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testEnableDisabledHalt [
	<ignoreNotImplementedSelectors: #(mHalt)>	
	haltController disableHaltNode: self node.
	self shouldnt: [ testObject mHalt ] raise: Halt.
	haltController enableHaltNode: self node.
	self should: [ testObject mHalt ] raise: Halt
]

{ #category : #'tests - breakpoints' }
StHaltAndBreakpointControllerTest >> testEnabledBreakpointIsEnabled [

	self assert: (haltController isBreakpointEnabled: breakpoint).
	self assert: (haltController isHaltOrBreakpointEnabled:
			 (StBreakpointInspectionItem forBreakpoint: breakpoint))
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testEnabledHaltIsEnabled [
	self assert: (haltController isHaltEnabledFor: self node)
]

{ #category : #'tests - breakpoints' }
StHaltAndBreakpointControllerTest >> testNoTraceForEnabledBreakpoint [
	<ignoreNotImplementedSelectors: #(mNoHalt)>
	[ testObject mNoHalt ]
		on: Halt
		do: [ :e | e resume ].
	self assert: trace isNil
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testNoTraceForEnabledHalt [
	<ignoreNotImplementedSelectors: #(mHalt)>
	[ testObject mHalt ]
		on: Halt
		do: [ :e | e resume ].
	self assert: trace isNil
]

{ #category : #'tests - halts' }
StHaltAndBreakpointControllerTest >> testTraceForDisabledHalt [
	<ignoreNotImplementedSelectors: #(mHalt)>
	haltController disableHaltNode: self node.
	testObject mHalt.
	self
		assert: trace
		equals: (StHaltAndBreakpointController printSkipTextFor: self node)
]
