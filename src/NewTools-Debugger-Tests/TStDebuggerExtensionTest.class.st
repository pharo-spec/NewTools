Class {
	#name : 'TStDebuggerExtensionTest',
	#superclass : 'TestCase',
	#instVars : [
		'traitUser'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
TStDebuggerExtensionTest >> setUp [
	super setUp.
	traitUser := TStDebuggerExtensionTestClass new
]

{ #category : 'running' }
TStDebuggerExtensionTest >> tearDown [

	traitUser class displayOrder: 1.
	traitUser := nil.
	TStDebuggerExtensionTestClass showInDebugger: false.
	super tearDown
]

{ #category : 'tests' }
TStDebuggerExtensionTest >> testDefaultDisplayOrder [
	self assert: TStDebuggerExtension defaultDisplayOrder equals: 1
]

{ #category : 'tests' }
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

{ #category : 'tests' }
TStDebuggerExtensionTest >> testExtensionToolNameIsExplicitRequirement [

	self assert: (TStDebuggerExtension>>#debuggerExtensionToolName) isExplicitlyRequired 
]

{ #category : 'tests' }
TStDebuggerExtensionTest >> testShowInDebugger [

	self deny: TStDebuggerExtension showInDebugger.
	traitUser class showInDebugger: true.
	self assert: traitUser class showInDebugger
]
