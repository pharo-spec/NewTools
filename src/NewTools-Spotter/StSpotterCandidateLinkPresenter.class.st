Class {
	#name : #StSpotterCandidateLinkPresenter,
	#superclass : #StSpotterPresenter,
	#instVars : [
		'iconPresenter',
		'labelPresenter',
		'model'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #accessing }
StSpotterCandidateLinkPresenter >> entry [

	^ self model value
]

{ #category : #initialization }
StSpotterCandidateLinkPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 2;
		spacing: 5;
		vAlignCenter;
		add: (iconPresenter := self newImage) expand: false;
		add: (labelPresenter := self newLabel);
		yourself).
		
	self addStyle: 'stSpotterLink'.
	iconPresenter image: self entry icon.
	labelPresenter label: self entry label
]

{ #category : #'accessing model' }
StSpotterCandidateLinkPresenter >> model [

	^ model
]

{ #category : #'accessing model' }
StSpotterCandidateLinkPresenter >> setModelBeforeInitialization: anEntry [

	model := anEntry
]
