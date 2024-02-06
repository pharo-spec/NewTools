Class {
	#name : 'StInspectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'inspector'
	],
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'running' }
StInspectorTest >> setUp [
	
	super setUp.
	inspector := StInspectorPresenter onObject: 42
	
]

{ #category : 'running' }
StInspectorTest >> tearDown [

	inspector window 
		ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : 'tests' }
StInspectorTest >> testBuildPresentationWithDoesNotUndertandShouldReturnCodePresenter [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithDnuingPresentation) pragmas first.

	context := collector contextFromPragma: pragma.
	
	"Smoke test -> creating an inspection presenter should not fail. Instead it should create an error presenter"
	context newInspectionPresenter
]

{ #category : 'tests' }
StInspectorTest >> testBuildPresentationWithFailureShouldReturnCodePresenter [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithFailingPresentation) pragmas first.

	context := collector contextFromPragma: pragma.
	
	"Smoke test -> creating an inspection presenter should not fail. Instead it should create an error presenter"
	context newInspectionPresenter
]

{ #category : 'tests' }
StInspectorTest >> testBuildPresentationWithHaltShouldReturnCodePresenter [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithHaltingPresentation) pragmas first.

	context := collector contextFromPragma: pragma.
	
	"Smoke test -> creating an inspection presenter should not fail. Instead it should create an error presenter"
	context newInspectionPresenter
]

{ #category : 'tests' }
StInspectorTest >> testConfigureContextWithDoesNotUnderstandShouldMarkContextAsError [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithDnuingContext) pragmas first.

	context := collector contextFromPragma: pragma.
	self assert: context isErrorContext
]

{ #category : 'tests' }
StInspectorTest >> testConfigureContextWithErrorShouldMarkContextAsError [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithFailingContext) pragmas first.

	context := collector contextFromPragma: pragma.
	self assert: context isErrorContext
]

{ #category : 'tests' }
StInspectorTest >> testConfigureContextWithHaltShouldMarkContextAsError [


	| collector pragma context |
	collector := StInspectionCollector on: StInspectorMockObject new.
	pragma := (StInspectorMockObject >> #methodWithHaltingContext) pragmas first.

	context := collector contextFromPragma: pragma.
	self assert: context isErrorContext
]

{ #category : 'tests' }
StInspectorTest >> testContextSelectorForBuilderSelector [

	| c |
	c := StInspectionContext new methodSelector: #selectorWithArgument:.
	
	self 
		assert: c contextMethodSelector
		equals: #selectorWithArgumentContext:
]

{ #category : 'tests' }
StInspectorTest >> testContextSelectorForNonBuilderSelector [

	| c |
	c := StInspectionContext new methodSelector: #selectorWithoutArgument.
	
	self 
		assert: c contextMethodSelector
		equals: #selectorWithoutArgumentContext:
]

{ #category : 'tests' }
StInspectorTest >> testDefaultKeyboardFocus [

	inspector open.
	self
		assert: inspector defaultKeyboardFocus
		equals: inspector millerList presenters first
]

{ #category : 'tests' }
StInspectorTest >> testDefineContextInSubclass [

	| c |
	c := StInspectionCollector on: StInspectorMockObjectSubclass new.

	self deny: (c contextFromPragma: (StInspectorMockObject >> #inspectionMock1) pragmas first) isActive
]

{ #category : 'tests' }
StInspectorTest >> testFirstPage [

	inspector open.
	self assert: inspector firstPage isNotNil.
	self assert:
		(inspector firstPage isKindOf: StObjectInspectorPresenter)
]

{ #category : 'tests' }
StInspectorTest >> testModel [

	self assert: inspector model inspectedObject equals: 42.
	
	inspector model: (StInspectorModel on: #fourtytwo).
	
	self assert: inspector model inspectedObject equals: #fourtytwo.
	self assert: inspector firstPage model equals: inspector model
]
