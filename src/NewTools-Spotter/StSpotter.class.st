Class {
	#name : #StSpotter,
	#superclass : #StPresenter,
	#instVars : [
		'searchText',
		'resultList',
		'model',
		'updating',
		'previewContainer'
	],
	#classVars : [
		'History'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #private }
StSpotter class >> basicHistory [

	^ History ifNil: [ History := WeakOrderedCollection new ]
]

{ #category : #private }
StSpotter class >> historize: aCandidateLink [

	self basicHistory 
		removeAllSuchThat: [ :each | each value = aCandidateLink value ];
		addFirst: aCandidateLink
]

{ #category : #accessing }
StSpotter class >> history [

	^ self basicHistory reject: [ :each | each isNil ]
]

{ #category : #accessing }
StSpotter class >> resetHistory [
	<script>
	"
	self resetHistory
	"
	History := nil
]

{ #category : #'private actions' }
StSpotter >> activate: aPresenter [

	aPresenter isHeader ifTrue: [ 
		self diveInProcessor: aPresenter model.
		^ self ].

	self window close.
	self historize: aPresenter model.
	aPresenter model value doEvaluate.

]

{ #category : #private }
StSpotter >> defaultModel [

	^ StSpotterModel new
		whenSearchUpdatedDo: [ self updateResultList ];
		yourself
]

{ #category : #'private updating' }
StSpotter >> deferredUpdateResultList [
	| resultsByClass presenters |
	
	resultsByClass := (self model links groupedBy: #processor) associations
		sorted: [ :each | each key order ] ascending.
	presenters := resultsByClass flatCollect: [ :eachAssoc | 
		{ self newSpotterHeaderPresenter: eachAssoc key }, 
		((eachAssoc value sorted: #className ascending, #asString ascending)
			collect: [ :eachLink | self newSpotterCandidateLinkPresenter: eachLink ]) ].
	
	resultList disableActivationDuring: [ 
		| index |
		index := resultList selection selectedIndex.
		resultList items: presenters.
		resultList selectIndex: index ]
]

{ #category : #'private actions' }
StSpotter >> diveInProcessor: aProcessor [
	
	self halt.
]

{ #category : #private }
StSpotter >> handleKeyEvent: anEvent [
			
	"go back to search text"
	anEvent keyCharacter isAlphaNumeric 
		ifTrue: [ searchText takeKeyboardFocus ]
]

{ #category : #'private actions' }
StSpotter >> historize: aCandidateLink [

	self class historize: aCandidateLink
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
			add: (previewContainer := SpBoxLayout newVertical);
			yourself);
		yourself).

	resultList
		bindKeyCombination: Character arrowUp asKeyCombination 
			toAction: [ :target :widget :event |
				self transferFocusToSearchText.
				event wasHandled: false ];
		whenSelectionChangedDo: [ :selection | 
			self showPreview: selection selectedItem ];
		whenActivatedDo: [ :selection | 
			self activate: selection selectedItem ].
	resultList eventHandler 
		whenKeyDownDo: [ :anEvent | self handleKeyEvent: anEvent ].

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
		centered.

	self model processors do: [ :each | 
		each installKeymappingsOn: aWindowPresenter ]
]

{ #category : #'accessing model' }
StSpotter >> model [

	^ model ifNil: [ model := self defaultModel ]
]

{ #category : #'private updating' }
StSpotter >> newSpotterCandidateLinkPresenter: aLink [

	^ self instantiate: StSpotterCandidateLinkPresenter on: aLink
]

{ #category : #'private updating' }
StSpotter >> newSpotterHeaderPresenter: aProcessor [

	^ (self instantiate: StSpotterHeaderPresenter on: aProcessor)
		whenDiveInDo: [ :processor | self diveInProcessor: processor ];
		yourself
]

{ #category : #'accessing model' }
StSpotter >> setModelBeforeInitialization: aSpotterModel [

	model := aSpotterModel.
	model whenSearchUpdatedDo: [  ]
]

{ #category : #'private actions' }
StSpotter >> showPreview: aPresenter [

	previewContainer removeAll.	
	(aPresenter isNil or: [ aPresenter isHeader ]) 
		ifTrue: [ ^ self ].

	aPresenter model value spotterPreview 
		ifNotNil: [ :previewPresenter | 
			previewContainer add: (previewPresenter 
				owner: self; 
				yourself) ]
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
