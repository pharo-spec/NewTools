Class {
	#name : #StInspection,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #'model access' }
StInspection >> model [
	^ model
]

{ #category : #'model access' }
StInspection >> model: anObject [
	model := anObject
]

{ #category : #'model access' }
StInspection >> setModelBeforeInitialization: anObject [ 

	model := anObject
]
