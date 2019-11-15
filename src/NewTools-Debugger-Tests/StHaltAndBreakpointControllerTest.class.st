Class {
	#name : #StHaltAndBreakpointControllerTest,
	#superclass : #StHaltAndBreakpointControlTest,
	#instVars : [
		'haltController',
		'testObject'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #running }
StHaltAndBreakpointControllerTest >> setUp [
	super setUp.
	testObject := StDummyTestClassWithHalts new.
	haltController := StHaltAndBreakpointController new 
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisableBreakpoint [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testDisableHalt [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnableDisabledBreakpoint [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testEnableDisabledHalt [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testNoTraceForEnabledHalt [
]

{ #category : #tests }
StHaltAndBreakpointControllerTest >> testTraceForDisabledHalt [
]
