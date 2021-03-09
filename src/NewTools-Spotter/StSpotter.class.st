Class {
	#name : #StSpotter,
	#superclass : #StPresenter,
	#instVars : [
		'searchText',
		'resultList',
		'model',
		'previewContainer',
		'categories',
		'mutex'
	],
	#classVars : [
		'History'
	],
	#classInstVars : [
		'spotterWindow'
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

{ #category : #'instance creation' }
StSpotter class >> open [

	self reset.
	^ spotterWindow := self new openModalWithSpec
]

{ #category : #'tools registry' }
StSpotter class >> registerToolsOn: registry [
	"self registerToolsOn: Smalltalk tools"

	registry register: self as: #spotter
]

{ #category : #private }
StSpotter class >> reset [
	
	spotterWindow ifNotNil: [ spotterWindow close ]
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
StSpotter >> configureModel: aModel [ 

	aModel 
		whenSearchUpdatedDo: [ :aCandidateLink | self updateResultList: aCandidateLink ];
		whenAmountChangedDo: [ :processor :amount | 
			self updateResultProcessor: processor amount: amount ]
]

{ #category : #private }
StSpotter >> defaultModel [

	^ StSpotterModel new
		in: [ :this | self configureModel: this ];
		yourself
]

{ #category : #'private updating' }
StSpotter >> deferredUpdateResultList: aCandidateLink [
	| categoryPresenter presenters |

	categoryPresenter := categories 
		at: aCandidateLink processor
		ifAbsentPut: [ self newSpotterHeaderPresenter: aCandidateLink processor ].
		
	categoryPresenter addCandidate: aCandidateLink inSpotter: self.
	
	presenters := (categories values 
		sorted: [ :each | each model order ] ascending)
		flatCollect: [ :each | each withCandidates ]. 
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
	
	(#( 30 "arrow up" 31 "arrow down" 13 "cr") includes: anEvent keyCharacter asInteger)
		ifFalse: [ searchText takeKeyboardFocus ]
]

{ #category : #'private actions' }
StSpotter >> historize: aCandidateLink [

	self class historize: aCandidateLink
]

{ #category : #initialization }
StSpotter >> initialize [

	mutex ifNil: [ mutex := Mutex new ].
	categories := Dictionary new.
	super initialize.
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
		add: (SpOverlayLayout new
			child: (SpBoxLayout newHorizontal
				beHomogeneous;
				spacing: 5;
				add: (resultList := self newComponentList);
				add: (previewContainer := SpBoxLayout newVertical);
				yourself);
			"addOverlay: self newSpinner withConstraints: [ :c | c vAlignCenter; hAlignCenter ];" 
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

	self addStyle: 'stSpotter'.
	searchText 
		placeholder: 'Search...';
		addStyle: 'stSpotterSearch';
		whenTextChangedDo: [ :aString | self updateSearch: aString ];
		bindKeyCombination: Character arrowDown asKeyCombination 
			toAction: [ self transferFocusToResultList ].
	resultList addStyle: 'stSpotterList'
]

{ #category : #initialization }
StSpotter >> initializeWindow: aWindowPresenter [

	self flag: #TODO. "Maybe calculate coordinates?"
	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		withoutDecorations;
		initialExtent: 750@450;
		whenOpenedDo: [ self startProcessing ];
		whenClosedDo: [ self stopProcessing ];
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

{ #category : #'private updating' }
StSpotter >> newSpotterHeaderPresenter: aProcessor amount: aNumber [

	^ (self newSpotterHeaderPresenter: aProcessor)
		"updateAmount: aNumber;"
		yourself
]

{ #category : #'accessing model' }
StSpotter >> setModelBeforeInitialization: aSpotterModel [

	model := aSpotterModel.
	self configureModel: model
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

	[ 
		"100 is a magic number we tested is enough to allow the UI to display the spotter"
		100 milliSeconds wait.
		self model startProcessing 
	] schedule
]

{ #category : #private }
StSpotter >> stopProcessing [
	"Start the process."

	self model stopProcessing
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
StSpotter >> updateResultList: aCandidateLink [

	[
		self application defer: [ 
			mutex critical: [
				self deferredUpdateResultList: aCandidateLink ] ]
	] schedule
]

{ #category : #'private updating' }
StSpotter >> updateResultProcessor: processor amount: amount [

	categories 
		at: processor 
		ifPresent: [ :aPresenter | aPresenter finalAmount: amount ]
]

{ #category : #'private updating' }
StSpotter >> updateSearch: aString [

	categories removeAll.
	self model asyncProcess: aString
]
