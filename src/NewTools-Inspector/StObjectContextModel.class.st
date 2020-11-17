"
A model to be used with `StObjectContextPresenter`.
It keeps references to: 

- the inspector model
- the inspection context
- the inspection object
"
Class {
	#name : #StObjectContextModel,
	#superclass : #Object,
	#instVars : [
		'inspection',
		'context',
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #accessing }
StObjectContextModel >> context [
	^ context
]

{ #category : #accessing }
StObjectContextModel >> context: anObject [
	context := anObject
]

{ #category : #'as yet unclassified' }
StObjectContextModel >> hasEvaluator [
	
	^ self context hasEvaluator
]

{ #category : #accessing }
StObjectContextModel >> inspectedObject [
	^ inspectedObject
]

{ #category : #accessing }
StObjectContextModel >> inspectedObject: anObject [
	inspectedObject := anObject
]

{ #category : #accessing }
StObjectContextModel >> inspection [
	^ inspection
]

{ #category : #accessing }
StObjectContextModel >> inspection: anObject [
	inspection := anObject
]

{ #category : #'as yet unclassified' }
StObjectContextModel >> newInspectionView [

	^ self context newInspectionView
]

{ #category : #accessing }
StObjectContextModel >> smallDescriptionString [

	^ self inspection smallDescriptionString
]
