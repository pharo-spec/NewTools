Class {
	#name : #OCBreakpointTest,
	#superclass : #TestCase,
	#instVars : [
		'object1',
		'object2',
		'breakpoint'
	],
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #helpers }
OCBreakpointTest >> assertBreakpointIsRegistered [
	self
		assert: (breakpoint registry registryAt: breakpoint targetObject) size
		equals: 1.
	self
		assertCollection: (breakpoint registry registryAt: breakpoint targetObject)
		includesAll: {breakpoint}
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnAccess [
	self should: [ object1 ivarRead ] raise: Break.
	self should: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnReadAccess [
	self should: [ object1 ivarRead ] raise: Break.
	self shouldnt: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnWriteAccess [
	self shouldnt: [ object1 ivarRead ] raise: Break.
	self should: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject2DoesNotBreakOnStateAccess [
	
	self shouldnt: [ object2 ivarRead ] raise: Break.
	self shouldnt: [ object2 ivarWrite ] raise: Break.
	self shouldnt: [ object2 ivarReadWrite] raise: Break.
	
]

{ #category : #helpers }
OCBreakpointTest >> assertOnlyTargetObjectBreaks [
	self should: [ object1 m1 ] raise: Break.
	self shouldnt: [ object1 m2 ] raise: Break.
	self shouldnt: [ object2 m1 ] raise: Break
]

{ #category : #running }
OCBreakpointTest >> setUp [
	super setUp.
	object1 := OCBreakpointTestObjectClass new.
	object2 := OCBreakpointTestObjectClass new
]

{ #category : #running }
OCBreakpointTest >> tearDown [
	OCBreakpoint uninstallAll.
	breakpoint := nil.
	super tearDown
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

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnCallTo [
	object1 haltOnCallTo: #m1.
	self assertOnlyTargetObjectBreaks
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

	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #all to: #ivar.
	self assertObject1BreaksOnAccess.
	self assertObject2DoesNotBreakOnStateAccess.
	self assertBreakpointIsRegistered.
	
	breakpoint uninstall.
	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #read to: #ivar.
	self assertObject1BreaksOnReadAccess.
	self assertObject2DoesNotBreakOnStateAccess.
	self assertBreakpointIsRegistered.
	
	breakpoint uninstall.
	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #write to: #ivar.
	self assertObject1BreaksOnWriteAccess.
	self assertObject2DoesNotBreakOnStateAccess.
	self assertBreakpointIsRegistered.
]

{ #category : #'api - on call' }
OCBreakpointTest >> testHaltTargetOnCallTo [
	OCBreakpoint new haltTarget: object1 onCallTo: #m1.
	self assertOnlyTargetObjectBreaks
]

{ #category : #installing }
OCBreakpointTest >> testInstallOnFor [
	breakpoint := OCBreakpoint new.
	breakpoint targetObject: object1.
	breakpoint installOn: object1 for: #m1.
	self assertOnlyTargetObjectBreaks
]

{ #category : #installing }
OCBreakpointTest >> testInstrumentedObjectClass [
	breakpoint := OCBreakpoint new haltTarget: object1 onCallTo: #m1.
	self assert: object1 class identicalTo: OCBreakpointTestObjectClass.
	self assertCollection: breakpoint link nodes hasSameElements: {(object1 species>>#m1) ast}.
]

{ #category : #'registry access' }
OCBreakpointTest >> testRegisterObjectCentricBreakpoint [
	breakpoint := OCBreakpoint new.
	breakpoint targetObject: object1.
	breakpoint registerObjectCentricBreakpoint.
	self assertBreakpointIsRegistered 
]

{ #category : #'registry access' }
OCBreakpointTest >> testRegistry [

	self assert: OCBreakpoint new registry identicalTo: OCBreakpoint 
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
	breakpoint := OCBreakpoint new haltTarget: object1 onCallTo: #m1.
	self assert: breakpoint targetObject identicalTo: object1
]

{ #category : #installing }
OCBreakpointTest >> testUninstall [
	breakpoint := OCBreakpoint new haltTarget: object1 onCallTo: #m1.
	breakpoint uninstall.
	self shouldnt: [ object1 m1 ] raise: Break.
	self assertEmpty: (breakpoint registry registryAt: object1). 
	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #read to: #ivar.
	breakpoint uninstall.
	self shouldnt: [ object1 ivarAccess ] raise: Break.
	self assertEmpty: (breakpoint registry registryAt: object1). 
]

{ #category : #installing }
OCBreakpointTest >> testinstallOnMethodNamed [
	breakpoint := OCBreakpoint new.
	breakpoint targetObject: object1.
	breakpoint installOnMethodNamed: #m1.
	self assertOnlyTargetObjectBreaks.
	self assertBreakpointIsRegistered 
]
