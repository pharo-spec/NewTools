Class {
	#name : #OCBreakpointTest,
	#superclass : #TestCase,
	#instVars : [
		'object1',
		'object2'
	],
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #running }
OCBreakpointTest >> setUp [
	object1 := MyTestObject new.
	object2 := MyTestObject new
]

{ #category : #running }
OCBreakpointTest >> tearDown [
	OCBreakpoint uninstallAll
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnAllAccesses [
	| obj1 obj2 cpt |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #all.
	cpt := 0.
	[ obj1 ivarReadAndWrite.
	obj1 tag.
	obj1 tagExec: nil ]
		on: Halt
		do: [ :halt | 
			cpt := cpt + 1.
			halt resume ].
	self assert: cpt equals: 4.
	self
		shouldnt: [ obj2 ivarReadAndWrite.
			obj2 tag.
			obj2 tagExec: nil ]
		raise: Halt
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnAllAccessesToIvar [
	| obj1 obj2 cpt |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #all to: #ivar.
	cpt := 0.
	[ obj1 ivarReadAndWrite ]
		on: Halt
		do: [ :halt | 
			cpt := cpt + 1.
			halt resume ].
	self assert: cpt equals: 2.	
	self shouldnt: [ obj2 ivarReadAndWrite ] raise: Halt
]

{ #category : #'api - on call' }
OCBreakpointTest >> testHaltOnCallTo [
	object1 haltOnCallTo: #m1.
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnCallToObjectAPI [
	object1 haltOnCallTo: #m1.
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnReadAccess [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #read.
	self should: [ obj1 ivarRead ] raise: Halt.
	self should: [ obj1 tag ] raise: Halt.
	self shouldnt: [ obj2 ivarRead ] raise: Halt.
	self shouldnt: [ obj2 tag ] raise: Halt
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnReadAccessToIvar [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #read to: #ivar.
	self should: [ obj1 ivarRead ] raise: Halt.
	self shouldnt: [ obj2 ivarRead ] raise: Halt
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnWriteAccess [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #write.
	self should: [ obj1 ivarWrite ] raise: Halt.
	self should: [ obj1 tagExec: nil ] raise: Halt.
	self shouldnt: [ obj2 ivarWrite ] raise: Halt.
	self shouldnt: [ obj2 tagExec: nil ] raise: Halt
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnWriteAccessToIvar [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #write to: #ivar.
	self should: [ obj1 ivarWrite ] raise: Halt.
	self shouldnt: [ obj2 ivarWrite ] raise: Halt
]

{ #category : #'api - state access' }
OCBreakpointTest >> testHaltTargetOnAccessTo [
]

{ #category : #'api - on call' }
OCBreakpointTest >> testHaltTargetOnCallTo [
	object1 haltOnCallTo: #m1.
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #installing }
OCBreakpointTest >> testInstallOnFor [
]

{ #category : #'registry access' }
OCBreakpointTest >> testRegisterObjectCentricBreakpoint [
]

{ #category : #'registry access' }
OCBreakpointTest >> testRegistry [
]

{ #category : #'api - object' }
OCBreakpointTest >> testRemoveHaltOnAccesses [
	| obj1 |
	obj1 := ReflectivityExamples new.
	obj1 haltOnAccess: #all.
	self assert: obj1 class isAnonymous.
	obj1 removeStateAccessHalts.
	self deny: obj1 class isAnonymous.
	self
		shouldnt: [ obj1 ivarReadAndWrite.
			obj1 tag.
			obj1 tagExec: nil ]
		raise: Halt
]

{ #category : #installing }
OCBreakpointTest >> testTargetObject [
]

{ #category : #installing }
OCBreakpointTest >> testUninstall [
]

{ #category : #installing }
OCBreakpointTest >> testinstallOnMethodNamed [
	object1 haltOnCallTo: #m1.
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]
