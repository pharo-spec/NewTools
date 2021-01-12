Class {
	#name : #StSpotter,
	#superclass : #StPresenter,
	#instVars : [
		'searchText',
		'resultList',
		'model'
	],
	#category : #'NewTools-Spotter'
}

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
			add: (resultList := self newComponentList);
			add: self newLabel;
			yourself);
		yourself).
		
	"resultList 
		display: [ :anEntry | anEntry asString ];
		displayIcon: [ :anEntry | anEntry icon ]; 
		bindKeyCombination: Character arrowUp asKeyCombination 
			toAction: [ self transferFocusToSearchText ]."
		
	searchText 
		placeholder: 'Search...';
		addStyle: 'stSpotter';
		whenTextChangedDo: [ :aString | self updateSearch: aString ];
		bindKeyCombination: Character arrowDown asKeyCombination 
			toAction: [ self transferFocusToResultList ]
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
StSpotter >> model [

	^ model ifNil: [ 
		model := StSpotterModel new
			whenSearchUpdatedDo: [ self updateResultList ];
			yourself ]
]

{ #category : #private }
StSpotter >> transferFocusToResultList [

	resultList items isEmptyOrNil ifTrue: [ ^ self ].
	
	resultList 
		selectIndex: 1;
		takeKeyboardFocus
]

{ #category : #private }
StSpotter >> transferFocusToSearchText [

	(resultList items notEmpty and: [ resultList selection selectedIndex = 1 ])
		ifTrue: [ searchText takeKeyboardFocus ].
		
	
]

{ #category : #'private updating' }
StSpotter >> updateResultList [ 

	self application defer: [ 
		| resultsByClass presenters |
		
		resultsByClass := self model results groupedBy: #class.
		presenters := resultsByClass associations flatCollect: [ :eachAssoc | 
			{ self instantiate: StSpotterHeaderPresenter on: eachAssoc key }, 
			((eachAssoc value sorted: #className ascending, #asString ascending)
				collect: [ :eachEntry | self instantiate: StSpotterEntryPresenter on: eachEntry ]) ].
		resultList updateItemsKeepingSelection: presenters ]
]

{ #category : #'private updating' }
StSpotter >> updateSearch: aString [

	aString size < 3 ifTrue: [ ^ self ].
	
	self model asyncProcess: aString
]
