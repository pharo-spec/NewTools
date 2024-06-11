Class {
	#name : 'StMetaInspectionTest',
	#superclass : 'StInspectionTest',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'running' }
StMetaInspectionTest >> newInspectionOn: anObject [
	"Answer a new inspection presenter for testing"

	^ (inspectionClass on: anObject) open presenter
]

{ #category : 'running' }
StMetaInspectionTest >> setUp [

	super setUp.
	inspectionClass := StMetaBrowserPresenter.

]

{ #category : 'running' }
StMetaInspectionTest >> tearDown [ 

	presenter ifNotNil: [ : p | p delete ].
	super tearDown.
]

{ #category : 'running' }
StMetaInspectionTest >> testInspectionMeta [

	presenter := self newInspectionOn: Object new.
	self 
		assert: Object new inspectionMeta class
		equals: inspectionClass
]

{ #category : 'running' }
StMetaInspectionTest >> testOpenAndClosePresenter [

	self
		shouldnt: [ 
			(inspectionClass on: Object new) 
				open;
				delete ]
		raise: Error
]

{ #category : 'running' }
StMetaInspectionTest >> testSelectedMethod [

	presenter := self newInspectionOn: Object new.
	self 
		assert: presenter selectedMethod isCompiledMethod
		description: 'It tests that when open on a non-empty class there is a selected method'

]

{ #category : 'running' }
StMetaInspectionTest >> testSelectedMethodEmptyClass [

	presenter := self newInspectionOn: StDummyEmptyClass new.
	self 
		assert: presenter selectedMethod isNil
		description: 'It tests that when open on a empty class has not a selected method'.


]
