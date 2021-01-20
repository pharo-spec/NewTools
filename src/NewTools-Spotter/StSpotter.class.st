Class {
	#name : #StSpotter,
	#superclass : #StPresenter,
	#instVars : [
		'searchText',
		'resultList',
		'model',
		'updating'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #private }
StSpotter >> activate: aPresenter [

	self window close.
	aPresenter model doEvaluate
]

{ #category : #'private updating' }
StSpotter >> deferredUpdateResultList [
	| resultsByClass presenters |
	
	resultsByClass := (self model links groupedBy: #processor) associations
		sorted: [ :each | each key order ] ascending.
	presenters := resultsByClass flatCollect: [ :eachAssoc | 
		{ self instantiate: StSpotterHeaderPresenter on: eachAssoc key }, 
		((eachAssoc value sorted: #className ascending, #asString ascending)
			collect: [ :eachLink | self instantiate: StSpotterEntryPresenter on: eachLink value ]) ].
	
	resultList updateItemsKeepingSelection: presenters
]

{ #category : #initialization }
StSpotter >> initialize [

	updating := false.
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
			add: (resultList := self newComponentList);
			add: self newLabel;
			yourself);
		yourself).
		
	"resultList 
		display: [ :anEntry | anEntry asString ];
		displayIcon: [ :anEntry | anEntry icon ]; 
		bindKeyCombination: Character arrowUp asKeyCombination 
			toAction: [ self transferFocusToSearchText ]."
	resultList whenActivatedDo: [ :selection | 
		self activate: selection selectedItem ].

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
		whenOpenedDo: [ self startProcessing ];
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
StSpotter >> startProcessing [
	"Start the process."

	[ self model startProcessing ] schedule
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

	updating ifTrue: [ ^ self  ].
	updating := true.
	self application defer: [ 
		[ self deferredUpdateResultList ]
		ensure: [ updating := false ] ]
]

{ #category : #'private updating' }
StSpotter >> updateSearch: aString [

	self model asyncProcess: aString
]
