Class {
	#name : #OCBreakpointTest,
	#superclass : #TestCase,
	#instVars : [
		'object1',
		'object2',
		'breakpoint'
	],
	#category : #'NewTools-ObjectCentricBreakpoints-Tests'
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
OCBreakpointTest >> assertObject1BreaksOnIvar2Access [
	self should: [ object1 ivar2Read ] raise: Break.
	self should: [ object1 ivar2Write ] raise: Break.
	self should: [ object1 ivar2ReadWrite ] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnIvar2ReadAccess [
	self should: [ object1 ivar2Read ] raise: Break.
	self shouldnt: [ object1 ivar2Write ] raise: Break.
	self should: [ object1 ivar2ReadWrite] raise: Break.
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnIvar2WriteAccess [
	self shouldnt: [ object1 ivar2Read ] raise: Break.
	self should: [ object1 ivar2Write ] raise: Break.
	self should: [ object1 ivar2ReadWrite] raise: Break.
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnIvarAccess [
	self should: [ object1 ivarRead ] raise: Break.
	self should: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite ] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnIvarReadAccess [
	self should: [ object1 ivarRead ] raise: Break.
	self shouldnt: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1BreaksOnIvarWriteAccess [
	self shouldnt: [ object1 ivarRead ] raise: Break.
	self should: [ object1 ivarWrite ] raise: Break.
	self should: [ object1 ivarReadWrite] raise: Break
]

{ #category : #helpers }
OCBreakpointTest >> assertObject1ShouldNotBreaksOnIvar2Access [
	self shouldnt: [ object1 ivar2Read ] raise: Break.
	self shouldnt: [ object1 ivar2Write ] raise: Break.
	self shouldnt: [ object1 ivar2ReadWrite] raise: Break.
]

{ #category : #helpers }
OCBreakpointTest >> assertObject2ShouldNotBreakOnIvarAccess [
	
	self shouldnt: [ object2 ivarRead ] raise: Break.
	self shouldnt: [ object2 ivarWrite ] raise: Break.
	self shouldnt: [ object2 ivarReadWrite] raise: Break.
	
]

{ #category : #helpers }
OCBreakpointTest >> assertObject2ShouldNotBreaksOnIvar2Access [

	self shouldnt: [ object2 ivar2Read ] raise: Break.
	self shouldnt: [ object2 ivar2Write ] raise: Break.
	self shouldnt: [ object2 ivar2ReadWrite] raise: Break.
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
	object1 haltOnStateAccess.
	self assertObject1BreaksOnIvarAccess.
	self assertObject1BreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access 
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnAllAccessesToIvar [
	object1 haltOnAccessTo: #ivar.
	self assertObject1BreaksOnIvarAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access 
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnCallTo [
	object1 haltOnCallTo: #m1.
	self assertOnlyTargetObjectBreaks
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnReadAccess [
	object1 haltOnRead.
	self assertObject1BreaksOnIvarReadAccess.
	self assertObject1BreaksOnIvar2ReadAccess.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnReadAccessToIvar [
	object1 haltOnReadTo: #ivar.
	self assertObject1BreaksOnIvarReadAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access 
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnWriteAccess [
	object1 haltOnWrite.
	self assertObject1BreaksOnIvarWriteAccess.
	self assertObject1BreaksOnIvar2WriteAccess.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access
]

{ #category : #'api - object' }
OCBreakpointTest >> testHaltOnWriteAccessToIvar [
	object1 haltOnWriteTo: #ivar.
	self assertObject1BreaksOnIvarWriteAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertObject2ShouldNotBreaksOnIvar2Access
]

{ #category : #'api - state access' }
OCBreakpointTest >> testHaltTargetOnAccessTo [

	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #all to: #ivar.
	self assertObject1BreaksOnIvarAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertBreakpointIsRegistered.
	
	breakpoint uninstall.
	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #read to: #ivar.
	self assertObject1BreaksOnIvarReadAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
	self assertBreakpointIsRegistered.
	
	breakpoint uninstall.
	breakpoint := OCBreakpoint new haltTarget: object1 onAccess: #write to: #ivar.
	self assertObject1BreaksOnIvarWriteAccess.
	self assertObject1ShouldNotBreaksOnIvar2Access.
	self assertObject2ShouldNotBreakOnIvarAccess.
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
	|realClass|
	
	breakpoint := OCBreakpoint new haltTarget: object1 onCallTo: #m1.
	self assert: object1 class identicalTo: OCBreakpointTestObjectClass.
	self assertCollection: breakpoint link nodes hasSameElements: {(object1 species>>#m1) ast}.
	
	realClass := (MetaLinkAnonymousClassBuilder new requestClassOfObject: object1).
	self assert: realClass isAnonymous. 
	self assert: realClass superclass identicalTo: OCBreakpointTestObjectClass.
	self assertCollection: breakpoint link nodes hasSameElements: {(realClass>>#m1) ast}.
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
	self shouldnt: [ object1 ivarRead ] raise: Break.
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
