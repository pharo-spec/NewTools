Class {
	#name : #TStDebuggerExtensionTest,
	#superclass : #TestCase,
	#instVars : [
		'traitUser'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #running }
TStDebuggerExtensionTest >> setUp [
	super setUp.
	StDebuggerExtensionGeneratorForTests generateTestClass.
	traitUser := StDebuggerExtensionGeneratorForTests testClass new
]

{ #category : #running }
TStDebuggerExtensionTest >> tearDown [
	traitUser := nil.
	StDebuggerExtensionGeneratorForTests removeTestClass.
	super tearDown
]

{ #category : #tests }
TStDebuggerExtensionTest >> testDefaultDisplayOrder [
	self assert: TStDebuggerExtension defaultDisplayOrder equals: 1
]

{ #category : #tests }
TStDebuggerExtensionTest >> testDisplayOrder [

	self
		assert: TStDebuggerExtension displayOrder
		equals: TStDebuggerExtension defaultDisplayOrder.
	self
		assert: traitUser displayOrder
		equals: TStDebuggerExtension displayOrder.
	traitUser class displayOrder: 10.
	self assert: traitUser displayOrder equals: 10
]

{ #category : #tests }
TStDebuggerExtensionTest >> testExtensionToolNameIsExplicitRequirement [

	self assert: (TStDebuggerExtension>>#debuggerExtensionToolName) isExplicitlyRequired 
]

{ #category : #tests }
TStDebuggerExtensionTest >> testShowInDebugger [

	self deny: TStDebuggerExtension showInDebugger.
	traitUser class showInDebugger: true.
	self assert: traitUser class showInDebugger
]

{ #category : #tests }
TStDebuggerExtensionTest >> testShowInDebuggerAnnouncement [

	| listener |
	listener := StDebuggerExtensionTestListener new.
	SystemAnnouncer uniqueInstance weak
		when: StDebuggerExtensionActivationToggle
		send: #tag:
		to: listener.
		
	self assert: listener tag isNil.
	traitUser class showInDebugger: true.
	self assert: listener tag class equals: StDebuggerExtensionActivationToggle 
]
