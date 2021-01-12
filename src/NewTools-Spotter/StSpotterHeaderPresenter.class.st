Class {
	#name : #StSpotterHeaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'labelPresenter',
		'model'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #initialization }
StSpotterHeaderPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 2;
		spacing: 5;
		add: (labelPresenter := self newLabel);
		yourself).
		
	labelPresenter label: self model name
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> model [

	^ model
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> setModelBeforeInitialization: anEntry [

	model := anEntry
]
