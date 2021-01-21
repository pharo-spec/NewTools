Class {
	#name : #StSpotterEntryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'iconPresenter',
		'labelPresenter',
		'model'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #initialization }
StSpotterEntryPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 2;
		spacing: 5;
		add: (iconPresenter := self newImage) expand: false;
		add: (labelPresenter := self newLabel);
		yourself).
		
	iconPresenter image: self model icon.
	labelPresenter label: self model label
]

{ #category : #'accessing model' }
StSpotterEntryPresenter >> model [

	^ model
]

{ #category : #'accessing model' }
StSpotterEntryPresenter >> setModelBeforeInitialization: anEntry [

	model := anEntry
]
