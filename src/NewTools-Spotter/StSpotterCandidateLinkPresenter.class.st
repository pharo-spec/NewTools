"
A presenter to show a candidate (an option that can be choosen). 

"
Class {
	#name : 'StSpotterCandidateLinkPresenter',
	#superclass : 'StSpotterBasePresenter',
	#instVars : [
		'iconPresenter',
		'labelPresenter',
		'model'
	],
	#category : 'NewTools-Spotter-View',
	#package : 'NewTools-Spotter',
	#tag : 'View'
}

{ #category : 'actions' }
StSpotterCandidateLinkPresenter >> activateOn: spotterPresenter [

	spotterPresenter activateLink: self model
]

{ #category : 'accessing' }
StSpotterCandidateLinkPresenter >> entry [

	^ self model value
]

{ #category : 'initialization' }
StSpotterCandidateLinkPresenter >> initializePresenters [

	self layout: (SpBoxLayout newLeftToRight
		borderWidth: 2;
		spacing: 5;
		vAlignCenter;
		add: (iconPresenter := self newImage) expand: false;
		add: (labelPresenter := self newLabel);
		yourself).
		
	self addStyle: 'stSpotterLink'
]

{ #category : 'testing' }
StSpotterCandidateLinkPresenter >> matchesText: aString [

	^ self model 
		ifNotNil: [ self model matchesText: aString ]
		ifNil: [ false ]
]

{ #category : 'accessing - model' }
StSpotterCandidateLinkPresenter >> model [

	^ model
]

{ #category : 'accessing - model' }
StSpotterCandidateLinkPresenter >> setModelBeforeInitialization: aCandidateLink [

	model := aCandidateLink
]

{ #category : 'initialization' }
StSpotterCandidateLinkPresenter >> updatePresenter [

	self entry ifNil: [ ^ self ]. 
	
	iconPresenter image: (self entry iconOn: self application).
	labelPresenter label: self entry label
]
