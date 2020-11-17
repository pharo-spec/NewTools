"
A presenter object inspection that is aware of the inspection context.
It is used to build enhance inspection view (e.g. show or not the evaluator).
"
Class {
	#name : #StObjectContextPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'view',
		'evaluator',
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #api }
StObjectContextPresenter >> activateOnDoubleClick [
	
	view activateOnDoubleClick
]

{ #category : #api }
StObjectContextPresenter >> activateOnSingleClick [
	
	view activateOnSingleClick
]

{ #category : #private }
StObjectContextPresenter >> evaluatorInitialText [

	^ '"{1}"
self ' 
	format: { self model smallDescriptionString }
]

{ #category : #testing }
StObjectContextPresenter >> hasEvaluator [

	^ self model hasEvaluator
]

{ #category : #testing }
StObjectContextPresenter >> hasOutputActivationPort [
	
	^ view hasOutputActivationPort
]

{ #category : #initialization }
StObjectContextPresenter >> initializePresenters [

	view := self model newInspectionView.
	self hasEvaluator
		ifTrue: [ self intializePresentersWithEvaluator ]
		ifFalse: [ self intializePresentersWithoutEvaluator ]
]

{ #category : #initialization }
StObjectContextPresenter >> intializePresentersWithEvaluator [
	
	evaluator := self newCode
		beForObject: self model inspectedObject;
		text: self evaluatorInitialText;
		yourself.
	
	self layout: (SpPanedLayout newVertical
		position: 70 percent;
		add: view;
		add: evaluator;
		yourself)
]

{ #category : #initialization }
StObjectContextPresenter >> intializePresentersWithoutEvaluator [
	
	self layout: (SpBoxLayout newVertical
		add: view;
		yourself)
]

{ #category : #'accessing model' }
StObjectContextPresenter >> model [

	^ model
]

{ #category : #ports }
StObjectContextPresenter >> outputActivationPort [
	
	^ view outputActivationPort
]

{ #category : #'accessing model' }
StObjectContextPresenter >> setModelBeforeInitialization: aModel [
	
	model := aModel
]
