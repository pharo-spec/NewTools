Class {
	#name : 'StSBPanel',
	#superclass : 'StPresenter',
	#instVars : [
		'model'
	],
	#category : 'NewTools-SystemBrowser-View',
	#package : 'NewTools-SystemBrowser',
	#tag : 'View'
}

{ #category : 'accessing model' }
StSBPanel >> model [

	^ model
]

{ #category : 'accessing model' }
StSBPanel >> setModelBeforeInitialization: anEnvironmentModel [

	model := anEnvironmentModel
]
