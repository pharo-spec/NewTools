Class {
	#name : #TStDebuggerExtensionTest,
	#superclass : #TestCase,
	#instVars : [
		'traitUser'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #running }
TStDebuggerExtensionTest >> generateTestClass [

	Object
		subclass: #TStDebuggerExtensionTestClass
		uses: TStDebuggerExtension
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'NewTools-Debugger-Tests-Model'
]

{ #category : #running }
TStDebuggerExtensionTest >> removeTestClass [

	Smalltalk
		at: #TStDebuggerExtensionTestClass
		ifPresent: [ :class | class removeFromSystem ]
]

{ #category : #running }
TStDebuggerExtensionTest >> setUp [
	super setUp.
	self generateTestClass.
	traitUser := self testClass new
]

{ #category : #running }
TStDebuggerExtensionTest >> tearDown [
	traitUser := nil.
	self removeTestClass.
	super tearDown
]

{ #category : #running }
TStDebuggerExtensionTest >> testClass [

	^ Smalltalk at: #TStDebuggerExtensionTestClass
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
TStDebuggerExtensionTest >> testShowByDefault [

	self deny: TStDebuggerExtension showByDefault.
	traitUser class showByDefault: true.
	self assert: traitUser class showByDefault
]
