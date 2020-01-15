Class {
	#name : #HaltOnCallTest,
	#superclass : #ObjectCentricHaltTest,
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #'Halt - any method' }
HaltOnCallTest >> testHaltOnAnyMethodCall [
	object1 breakOnCall.
	self should: [ object1 m1 ] raise: Break.
	self should: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #'Halt - any method' }
HaltOnCallTest >> testHaltOnSpecificMethod [
	object1 breakOnCall: #m1.
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #'Halt - any method' }
HaltOnCallTest >> testMethodInvokationDoesNotHalt [
	object1 breakOnCall.

	self should:  [object1 m3]  raise: Break.
]
