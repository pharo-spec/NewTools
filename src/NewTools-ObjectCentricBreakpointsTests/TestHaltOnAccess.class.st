Class {
	#name : #TestHaltOnAccess,
	#superclass : #TestCase,
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #running }
TestHaltOnAccess >> setUp [
	MetaLink uninstallAll
]

{ #category : #running }
TestHaltOnAccess >> tearDown [
	MetaLink uninstallAll
]

{ #category : #tests }
TestHaltOnAccess >> testHaltOnAllAccesses [
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

{ #category : #tests }
TestHaltOnAccess >> testHaltOnAllAccessesToIvar [
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

{ #category : #tests }
TestHaltOnAccess >> testHaltOnReadAccess [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #read.
	self should: [ obj1 ivarRead ] raise: Halt.
	self should: [ obj1 tag ] raise: Halt.
	self shouldnt: [ obj2 ivarRead ] raise: Halt.
	self shouldnt: [ obj2 tag ] raise: Halt
]

{ #category : #tests }
TestHaltOnAccess >> testHaltOnReadAccessToIvar [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #read to: #ivar.
	self should: [ obj1 ivarRead ] raise: Halt.
	self shouldnt: [ obj2 ivarRead ] raise: Halt
]

{ #category : #tests }
TestHaltOnAccess >> testHaltOnWriteAccess [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #write.
	self should: [ obj1 ivarWrite ] raise: Halt.
	self should: [ obj1 tagExec: nil ] raise: Halt.
	self shouldnt: [ obj2 ivarWrite ] raise: Halt.
	self shouldnt: [ obj2 tagExec: nil ] raise: Halt
]

{ #category : #tests }
TestHaltOnAccess >> testHaltOnWriteAccessToIvar [
	| obj1 obj2 |
	obj1 := ReflectivityExamples new.
	obj2 := ReflectivityExamples new.
	obj1 haltOnAccess: #write to: #ivar.
	self should: [ obj1 ivarWrite ] raise: Halt.
	self shouldnt: [ obj2 ivarWrite ] raise: Halt
]

{ #category : #tests }
TestHaltOnAccess >> testRemoveHaltOnAccesses [
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
