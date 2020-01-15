Class {
	#name : #HaltOnInvokeTest,
	#superclass : #ObjectCentricHaltTest,
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #running }
HaltOnInvokeTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
		super setUp.
]

{ #category : #running }
HaltOnInvokeTest >> tearDown [
	"Hooks that subclasses may override to clean the fixture of test."
	super tearDown.
]

{ #category : #tests }
HaltOnInvokeTest >> testHaltOnAnyMethodCall [
	object1 breakOnCall.
	object1 m3.
	self should: [ object1 m3 ] raise: Break.
"	self should: [ object1 m2 ] raise: Break."
	self shouldnt: [ object2 m1 ] raise: Break
]
