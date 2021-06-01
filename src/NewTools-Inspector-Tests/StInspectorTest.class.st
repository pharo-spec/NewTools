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
StInspectorTest >> testFirstPage [

	inspector openWithSpec.
	self assert: inspector firstPage notNil.
	self assert: (inspector firstPage isKindOf: StObjectInspectorPresenter)
]
