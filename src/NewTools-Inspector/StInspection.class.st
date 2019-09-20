Class {
	#name : #StInspection,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #converting }
StInspection >> asInspection [

	^ self
]

{ #category : #'model access' }
StInspection >> model [
	^ model
]

{ #category : #'model access' }
StInspection >> model: anInspectionModel [

	model := anInspectionModel
]

{ #category : #'model access' }
StInspection >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]
