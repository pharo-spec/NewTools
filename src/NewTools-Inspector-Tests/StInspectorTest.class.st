Class {
	#name : #StInspectorTest,
	#superclass : #TestCase,
	#instVars : [
		'inspector'
	],
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #running }
StInspectorTest >> setUp [
	
	super setUp.
	inspector := StInspector onObject: 42
	
]

{ #category : #running }
StInspectorTest >> tearDown [

	inspector window 
		ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
StInspectorTest >> testContextSelectorForBuilderSelector [

	| c |
	c := StInspectionContext new methodSelector: #selectorWithArgument:.
	
	self 
		assert: c contextMethodSelector
		equals: #selectorWithArgumentContext:
]

{ #category : #tests }
StInspectorTest >> testContextSelectorForNonBuilderSelector [

	| c |
	c := StInspectionContext new methodSelector: #selectorWithoutArgument.
	
	self 
		assert: c contextMethodSelector
		equals: #selectorWithoutArgumentContext:
]

{ #category : #tests }
StInspectorTest >> testDefaultKeyboardFocus [

	inspector openWithSpec.
	self 
		assert: inspector defaultKeyboardFocus 
		equals: inspector millerList presenters first
]

{ #category : #tests }
StInspectorTest >> testDefineContextInSubclass [

	| c |
	c := StInspectionCollector on: StInspectorMockObjectSubclass new.

	self deny: (c contextFromPragma: (StInspectorMockObject >> #inspectionMock1) pragmas first) isActive
]

{ #category : #tests }
StInspectorTest >> testFirstPage [

	inspector openWithSpec.
	self assert: inspector firstPage notNil.
	self assert: (inspector firstPage isKindOf: StObjectInspectorPresenter)
]

{ #category : #tests }
StInspectorTest >> testModel [

	self assert: inspector model inspectedObject equals: 42.
	
	inspector model: (StInspectorModel on: #fourtytwo).
	
	self assert: inspector model inspectedObject equals: #fourtytwo.
	self assert: inspector firstPage model equals: inspector model
]
