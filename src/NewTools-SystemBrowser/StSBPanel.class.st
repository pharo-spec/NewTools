Class {
	#name : #StSBPanel,
	#superclass : #ComposablePresenter,
	#instVars : [
		'model'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #'accessing model' }
StSBPanel >> model [

	^ model
]

{ #category : #'accessing model' }
StSBPanel >> setModelBeforeInitialization: anEnvironmentModel [

	model := anEnvironmentModel
]
