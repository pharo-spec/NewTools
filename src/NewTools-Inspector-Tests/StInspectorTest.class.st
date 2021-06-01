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
StInspectorTest >> testDefaultKeyboardFocus [

	inspector openWithSpec.
	self 
		assert: inspector defaultKeyboardFocus 
		equals: inspector millerList presenters first
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
