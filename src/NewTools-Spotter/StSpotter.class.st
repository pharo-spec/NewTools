Class {
	#name : #StSpotter,
	#superclass : #StPresenter,
	#instVars : [
		'searchText',
		'resultList',
		'processor'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #initialization }
StSpotter >> initialize [

	processor := StSpotterProcessor new.
	super initialize
]

{ #category : #initialization }
StSpotter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter closeOnBackdropClick: true
]

{ #category : #initialization }
StSpotter >> initializePresenters [

	self layout: (SpBoxLayout newVertical
		borderWidth: 10;
		spacing: 5;
		add: (searchText := self newSearchInput) expand: false;
		add: (SpBoxLayout newHorizontal
			beHomogeneous;
			spacing: 5;
			add: (resultList := self newList);
			add: self newList;
			yourself);
		yourself).
		
	searchText 
		placeholder: 'Search...';
		addStyle: 'stSpotter'
]

{ #category : #initialization }
StSpotter >> initializeWindow: aWindowPresenter [

	self flag: #TODO. "Maybe calculate coordinates?"
	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		withoutDecorations;
		initialExtent: 750@400;
		centered
]

{ #category : #accessing }
StSpotter >> processor [
	
	^ processor
]
