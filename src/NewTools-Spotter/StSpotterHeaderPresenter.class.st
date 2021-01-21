Class {
	#name : #StSpotterHeaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'labelPresenter',
		'model',
		'shortcutPresenter'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #initialization }
StSpotterHeaderPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 2;
		spacing: 5;
		add: (labelPresenter := self newLabel);
		add: (shortcutPresenter := self newLabel);
		yourself).

	shortcutPresenter addStyle: 'dim'
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> model [

	^ model
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> setModelBeforeInitialization: aProcessor [

	model := aProcessor
]

{ #category : #initialization }
StSpotterHeaderPresenter >> updatePresenter [

	labelPresenter label: self model title
]
