"
When exploring the system, is useful to have a single entry point that will allow users to search for different component of the system. 
Spotter provides such entry point and is usually available by pressing <meta+enter>.

Spotter is just a front-end to show the result of different processors (see *StSpotterProcessor*) that provide results. Those processors can be configured in different ways and will provide different access options. 

Some known processors and options are: 

## Classes processor: 
- Type #classes in the search bar
- Press <meta+b>

## Implementors processor: 
- Type #implementors in the search bar
- Press <meta+m>

## Senders processor: 
- Type #senders in the search bar
- Press <meta+n>
"
Class {
	#name : 'StSpotter',
	#superclass : 'StPresenter',
	#instVars : [
		'searchText',
		'resultList',
		'model',
		'previewContainer',
		'categories',
		'mutex',
		'spinner',
		'tip',
		'queue',
		'updating',
		'lastSelectedEntry',
		'lastUpdateTime'
	],
	#classVars : [
		'History',
		'InsertsSelection',
		'PreviewVisible',
		'Tips',
		'TipsVisible'
	],
	#classInstVars : [
		'spotter'
	],
	#category : 'NewTools-Spotter-View',
	#package : 'NewTools-Spotter',
	#tag : 'View'
}

{ #category : 'private' }
StSpotter class >> basicHistory [

	^ History ifNil: [ History := WeakOrderedCollection new ]
]

{ #category : 'private' }
StSpotter class >> createTips [

	^ {
		'<meta+b> filters for Classes'.
		'<meta+m> filters for Implementors'.
		'<meta+n> filters for Senders'.
		'<meta+p> filters for Packages'.
		'<meta+h> filters for Help topics'.
		'Adding #Classes in the query filters for Classes'.
		'Adding #Implementors in the query filters for Implementors'.
		'Adding #Help in the query filters for Help Topics'.
		'Adding #Packages in the query filters for Packages'.
		'Adding #Menu in the query filters for System Menu entries'.
		'Using words separated with spaces looks up for all of them'.
		'Using camel case looks up for all of the parts'.
		'Clicking in the question mark shows another tip'.
		'Clicking in this tip shows another tip'.
	}
]

{ #category : 'accessing' }
StSpotter class >> hidePreview [
	<script>

	PreviewVisible := false
]

{ #category : 'accessing' }
StSpotter class >> hideTips [
	<script>

	TipsVisible := false
]

{ #category : 'private' }
StSpotter class >> historize: aCandidateLink [

	self basicHistory 
		removeAllSuchThat: [ :each | each value = aCandidateLink value ];
		addFirst: aCandidateLink
]

{ #category : 'accessing' }
StSpotter class >> history [

	^ self basicHistory reject: [ :each | each isNil ]
]

{ #category : 'class initialization' }
StSpotter class >> initialize [

	self showPreview.
	self showTips.
	self insertsSelection: true.
]

{ #category : 'settings' }
StSpotter class >> insertsSelection [
		
	^ InsertsSelection ifNil: [ InsertsSelection := false ]
]

{ #category : 'settings' }
StSpotter class >> insertsSelection: aBoolean [
		
	InsertsSelection := aBoolean
]

{ #category : 'testing' }
StSpotter class >> isShowingPreview [

	^ PreviewVisible
]

{ #category : 'testing' }
StSpotter class >> isShowingTips [

	^ TipsVisible
]

{ #category : 'world menu' }
StSpotter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Spotter)
		action: [ Smalltalk tools spotter open ];
		keyText: 'Shift + Enter';
		order: 1;
		parent: #Searching;
		help: 'Search tool to explore Pharo system effectively.';
		iconName: #smallFind
]

{ #category : 'instance creation' }
StSpotter class >> newWithText: aText [

	self reset.
	spotter := self new.
	spotter searchText
		text: aText asString;
		selectAll.
	^ spotter 
]

{ #category : 'instance creation' }
StSpotter class >> open [

	self openWithText: ''
]

{ #category : 'instance creation' }
StSpotter class >> openOn: aModel [

	self reset.
	spotter := self on: aModel.
	^ spotter openModal
]

{ #category : 'instance creation' }
StSpotter class >> openOnOrigin: anObject [

	^ self openOn: (StSpotterModel newOrigin: anObject)
]

{ #category : 'instance creation' }
StSpotter class >> openWithText: aText [

	^ (self newWithText: aText) openModal
]

{ #category : 'settings' }
StSpotter class >> previewVisible [
		
	^ PreviewVisible
]

{ #category : 'settings' }
StSpotter class >> previewVisible: aBoolean [
	
	PreviewVisible := aBoolean
]

{ #category : 'tools registry' }
StSpotter class >> registerToolsOn: registry [
	"self registerToolsOn: Smalltalk tools"

	registry register: self as: #spotter
]

{ #category : 'class initialization' }
StSpotter class >> reset [
	
	spotter ifNotNil: [ 
		spotter withWindowDo: [ :window | window close ].
		spotter := nil ]
]

{ #category : 'accessing' }
StSpotter class >> resetHistory [
	<script>
	"
	self resetHistory
	"
	History := nil
]

{ #category : 'settings' }
StSpotter class >> settingsOn: aBuilder [
	<systemsettings>

	(aBuilder group: #spotter)
		parent: #tools;
		label: 'Spotter';
		description: 'Spotter configuration'.

	(aBuilder setting: #previewVisible)
		parent: #spotter;
		default: self isShowingPreview;
		target: self;
		description: 'If Spotter will show the preview panel on the right of spotter';
		label: 'Show Preview Panel'.
		
	(aBuilder setting: #tipsVisible)
		parent: #spotter;
		default: self isShowingTips;
		target: self;
		description: 'If Spotter will show the tips at the bottom of spotter';
		label: 'Show Tips Panel'.
		
	(aBuilder setting: #insertsSelection)
		parent: #spotter;
		default: self insertsSelection;
		target: self;
		description: 'When the Spotter is opened, automatically insert the selected text into the search field';
		label: 'Inserts Selection'.
]

{ #category : 'accessing' }
StSpotter class >> showPreview [
	<script>
	
	PreviewVisible := true
]

{ #category : 'accessing' }
StSpotter class >> showTips [
	<script>
	
	TipsVisible := true
]

{ #category : 'private' }
StSpotter class >> tips [ 

	^ Tips ifNil: [ Tips := self createTips ]
]

{ #category : 'settings' }
StSpotter class >> tipsVisible [
		
	^ TipsVisible
]

{ #category : 'settings' }
StSpotter class >> tipsVisible: aBoolean [
		
	TipsVisible := aBoolean
]

{ #category : 'private' }
StSpotter class >> windowClosed [

	spotter := nil
]

{ #category : 'private - actions' }
StSpotter >> activate: aPresenter [

	aPresenter ifNil: [ ^ self ].
	aPresenter activateOn: self
]

{ #category : 'private - actions' }
StSpotter >> activateLink: aCandidateLink [

	self window close.
	self historize: aCandidateLink.
	aCandidateLink value evaluateFor: self
]

{ #category : 'initialization' }
StSpotter >> addPreviewPanelTo: contentsLayout [

	contentsLayout 	add: (previewContainer := SpBoxLayout newTopToBottom).
	resultList whenSelectionChangedDo: [ :selection | 
		self showPreview: selection selectedItem ]
]

{ #category : 'initialization' }
StSpotter >> addTipsPanel [ 

	self layout: (SpBoxLayout newTopToBottom
		add: self layout;
		add: (SpBoxLayout newLeftToRight
				vAlignCenter;
				borderWidth: 3;
				spacing: 3;
				add: (self newImage 
					image: (self application iconNamed: #smallHelp);
					in: [ :this | this eventHandler whenMouseDownDo: [ :anEvent | self feedTip ] ];
					yourself)
					expand: false;
				add: ((tip := self newLabel)
					in: [ :this | this eventHandler whenMouseDownDo: [ :anEvent | self feedTip ] ];
					yourself);
				addLast: (SpBoxLayout newTopToBottom 
					add: (self newLink 
						label: 'Advanced Search...';
						action: [ self openFinder ];
						yourself);
					yourself)
					expand: false;
				yourself)
			expand: false;
		yourself)
]

{ #category : 'private' }
StSpotter >> allowUIToDraw [

	"5 is a magic number we tested is enough to allow the UI to display the spotter"
	5 timesRepeat: [ Processor yield ].

]

{ #category : 'private' }
StSpotter >> configureModel: aModel [ 

	aModel 
		whenNoResultsDo: [ self removeAllResults ];
		"whenSearchUpdatedDo: [ :aCandidateLink | 
			self updateResultList: aCandidateLink ];"
		whenAmountChangedDo: [ :processor :amount | 
			self updateResultProcessor: processor amount: amount ];
		whenQueryStartedDo: [ self showSpinner ];
		whenQueryEndedDo: [ self hideSpinner ]
]

{ #category : 'private' }
StSpotter >> defaultModel [

	^ self newModel
		in: [ :this | self configureModel: this ];
		yourself
]

{ #category : 'private - actions' }
StSpotter >> diveInProcessor: aProcessor [

	self model schedule: [
		self showSpinner.
		self resetLastSelectedEntry.
		self removeAllResults.
		self model pushStepForProcessor: aProcessor.
		resultList verticalAlignment desiredVisibleRow: 1.
		searchText text: '' ]
]

{ #category : 'private - actions' }
StSpotter >> diveOut [

	self resetLastSelectedEntry.
	self removeAllResults.
	self model popStep.
	self model lastSearchText ifNotNil: [ :aString | 
		searchText text: aString.
		searchText cursorPositionIndex: aString size + 1 ]
]

{ #category : 'actions' }
StSpotter >> feedTip [
	
	tip ifNil: [ ^ self ].
	tip label: self class tips atRandom
]

{ #category : 'private - updating' }
StSpotter >> flushPendingUpdates [

	self defer: [ 
		self model schedule: [ 
			mutex critical: [ 
				[ 
				self queuedUpdateResultList.
				lastUpdateTime := Time millisecondClockValue ]
					on: Exception
					fork: [ :e | 
						"Allow halts and that, but eat errors (since otherwise, ugly things can happen)"
						(e isKindOf: Error)
							ifTrue: [ ('Spotter error: ' , e printString) crTrace ]
							ifFalse: [ e pass ] ] ] ] ]
]

{ #category : 'private' }
StSpotter >> handleKeyEvent: anEvent [
	
	(#( 30 "arrow up" 31 "arrow down" 13 "cr") includes: anEvent keyCharacter asInteger)
		ifFalse: [ searchText takeKeyboardFocus ]
]

{ #category : 'private - updating' }
StSpotter >> headerCategoryFor: aLink [

	^ categories 
		at: aLink processor
		ifAbsentPut: [ self newSpotterHeaderPresenter: aLink processor ]
]

{ #category : 'private - updating' }
StSpotter >> headerCategoryUnifiedFor: aLink [

	^ categories 
		at: aLink value class
		ifAbsentPut: [ 
			(self newSpotterHeaderPresenter: aLink processor)
				type: aLink value class;
				yourself ]
]

{ #category : 'private - actions' }
StSpotter >> hideSpinner [

	self defer: [ spinner hide ]
]

{ #category : 'private - actions' }
StSpotter >> historize: aCandidateLink [

	self class historize: aCandidateLink
]

{ #category : 'initialization' }
StSpotter >> initialExtent [

	self flag: #TODO. "Maybe calculate coordinates?"
	^ self isShowingPreview 
		ifTrue: [ (750@450) ]
		ifFalse: [ (500@450) ]
]

{ #category : 'initialization' }
StSpotter >> initialize [

	mutex ifNil: [ mutex := Mutex new ].
	queue := OrderedCollection new.
	updating := false.
	categories := Dictionary new.
	super initialize
]

{ #category : 'initialization' }
StSpotter >> initializeDialogWindow: aDialogWindowPresenter [
 
	aDialogWindowPresenter closeOnBackdropClick: true
]

{ #category : 'initialization' }
StSpotter >> initializeLayout [
	| contentsLayout |

	self layout: (SpBoxLayout newTopToBottom
		borderWidth: 10;
		spacing: 5;
		add: searchText expand: false;
		add: (SpOverlayLayout new
			child: ((contentsLayout := SpBoxLayout newLeftToRight)
				beHomogeneous;
				spacing: 5;
				add: resultList;
				yourself);
			addOverlay: (spinner := self newSpinner)
				withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
			yourself);
		yourself).

	self isShowingPreview ifTrue: [ self addPreviewPanelTo: contentsLayout ].
	self isShowingTips ifTrue: [ self addTipsPanel ]
]

{ #category : 'initialization' }
StSpotter >> initializePresenters [

	resultList := self newComponentList.
	searchText := self newSearchInput.

	self initializeLayout.

	self addStyle: 'stSpotter'.
	spinner hide.

	resultList
		addStyle: 'stSpotterList';
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowUp asKeyCombination;
			action: [ self transferFocusToSearchTextArrowUp ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowDown asKeyCombination;
			action: [ self transferFocusToSearchTextArrowDown ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowRight asKeyCombination;
			action: [ self tryDiveIn ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowLeft asKeyCombination;
			action: [ self tryDiveOut ] ];
		whenActivatedDo: [ :selection |
			self activate: selection selectedItem ].
	resultList eventHandler
		whenKeyDownDo: [ :anEvent | self handleKeyEvent: anEvent ].

	searchText
		placeholder: 'Search...';
		addStyle: 'stSpotterSearch';
		whenTextChangedDo: [ :aString | self updateSearch: aString ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowDown asKeyCombination;
			action: [ self transferFocusToResultList ] ];		
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowUp asKeyCombination;
			action: [ self transferFocusToResultListAtLast ] ];		
		addShortcutWith: [ :action | action 
			shortcutKey: Character cr asKeyCombination;
			action: [ self maybeActivateFirstElementOfResultList ] ]
]

{ #category : 'initialization' }
StSpotter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Spotter';
		withoutDecorations;
		initialExtent: self initialExtent;
		whenOpenedDo: [ self startProcessing ];
		whenClosedDo: [ 
			self stopProcessing.
			self class windowClosed ];
		centered.

	self flag: #TODO. "This is more or less hacky, since I am using the processors that are
	relevant to the first level of spotter as the only ones, but for now it is working"
	self model activeProcessors do: [ :each | 
		each 
			installKeymappingsOn: aWindowPresenter
			onExecution: [ :aProcessor | self updateSearchFromProcessor: aProcessor ] ]
]

{ #category : 'testing' }
StSpotter >> insertsSelection [

	^ self class insertsSelection
]

{ #category : 'testing' }
StSpotter >> isShowingPreview [

	^ self class isShowingPreview
]

{ #category : 'testing' }
StSpotter >> isShowingTips [

	^ self class isShowingTips
]

{ #category : 'private - processing' }
StSpotter >> keepLastSelectedEntry [
	"When starting a process (a new query), it may happen that I have already a selection on the 
	 result list. Since my new query may be a refination (or expansion) of an existing search. 
	 As an explication, if you search for the string 'Obje', what in fact happens in spotter is that 
	 several search starts and resuls are produced before having time of cancelling it. 
	 So, you may be browsing the result of the search 'Obj' to select 'Object', 
	 then the results of the search 'Obje' start to arrive... we need to keep the entry selected to 
	 ensure the selection of 'Object' will stay there when the new results arrive."

	lastSelectedEntry := resultList selectedItem 
		ifNotNil: [ :aPresenter | aPresenter model value ]
]

{ #category : 'private - actions' }
StSpotter >> maybeActivateFirstElementOfResultList [
	"| text |

	text := self searchingString.
	resultList presenters
		detect: [ :each | each matchesText: text ]
		ifFound: [ :aPresenter | self activate: aPresenter ]."
		
	self activate: resultList selectedItem 
]

{ #category : 'accessing - model' }
StSpotter >> model [

	^ model ifNil: [ model := self defaultModel ]
]

{ #category : 'private' }
StSpotter >> newModel [
		
	^ StSpotterModel new
]

{ #category : 'private - factory' }
StSpotter >> newSpotterCandidateLinkPresenter: aLink [

	^ self instantiate: StSpotterCandidateLinkPresenter on: aLink
]

{ #category : 'private - factory' }
StSpotter >> newSpotterHeaderPresenter: aProcessor [

	^ (self instantiate: StSpotterHeaderPresenter on: aProcessor)
		nested: self model isNested;
		whenDiveInDo: [ :processor | self diveInProcessor: processor ];
		whenDiveOutDo: [ self diveOut ];
		yourself
]

{ #category : 'private - updating' }
StSpotter >> nextSelectablePresenter: selectedPresenter oldPresenters: oldPresenters newPresenters: newPresenters [

	"look for current selected presenter"	
	| text |
	(selectedPresenter isNotNil and: [ selectedPresenter model isNotNil ]) ifTrue: [ 	
		newPresenters 
			detect: [ :each | each model value = selectedPresenter model value ]
			ifFound: [ :aPresenter | ^ aPresenter ] ].
	"not found, look for last selected"
	lastSelectedEntry ifNotNil: [ 
		newPresenters 
			detect: [ :each | each model value = lastSelectedEntry ]
			ifFound: [ :aPresenter | ^ aPresenter ] ].
	"select first in list that matches"
	text := self searchingString.
	newPresenters
		detect: [ :each | each matchesText: text ]
		ifFound: [ :aPresenter | ^ aPresenter ]. 
	"select first in list that is not a header"
	newPresenters
		detect: [ :each | each isHeader not ]
		ifFound: [ :aPresenter | ^ aPresenter ]. 
	
	^ nil
]

{ #category : 'actions' }
StSpotter >> openFinder [

	self window close.
	self flag: #TODO. "Move finder to spec (right now is a morph)"
	FinderUI open
]

{ #category : 'private' }
StSpotter >> previewContainer [

	^ previewContainer
]

{ #category : 'private - updating' }
StSpotter >> queuedUpdateResultList [
	| categoryPresenter presenters selectedPresenter |

	updating ifTrue: [ ^ self ].
	updating := true.

	[  
		[ queue isEmpty ] 
		whileFalse: [ | aCandidateLink |
			aCandidateLink := queue removeFirst.
			categoryPresenter := aCandidateLink processor 
				headerCategoryFor: aCandidateLink
				on: self.
			(categoryPresenter includesLink: aCandidateLink) ifFalse: [ 
				categoryPresenter addCandidate: aCandidateLink inSpotter: self ] ].
	
		categories ifEmpty: [ ^ self ].
		presenters := (categories values 
			sorted: [ :each | each order ] ascending)
			flatCollect: [ :each | each withCandidates ]. 
	
		selectedPresenter := self 
			nextSelectablePresenter: resultList selectedItem
			oldPresenters: resultList presenters
			newPresenters: presenters.
		resultList presenters: presenters.
		selectedPresenter 
			ifNotNil: [ resultList selectItem: selectedPresenter ].
	]
	ensure: [ 
		updating := false ]
]

{ #category : 'private' }
StSpotter >> removeAll [

	mutex critical: [ queue removeAll ]. 
	categories removeAll.
	self allowUIToDraw
]

{ #category : 'private' }
StSpotter >> removeAllResults [

	resultList presenters: #().
	self removeAll
]

{ #category : 'private - processing' }
StSpotter >> resetLastSelectedEntry [
	
	lastSelectedEntry := nil
]

{ #category : 'private' }
StSpotter >> searchText [

	^ searchText
]

{ #category : 'private - actions' }
StSpotter >> searchingString [
	| searchString searchChunks |
	
	searchString := searchText text trimmed.
	searchChunks := searchString substrings.
	^ (searchChunks anySatisfy: [ :each | each first = $# ])
		ifTrue: [ ' ' join: (searchChunks reject: [ :each | each first = $# ]) ]
		ifFalse: [ searchString ]
]

{ #category : 'accessing - model' }
StSpotter >> setModelBeforeInitialization: aSpotterModel [

	model := aSpotterModel.
	self configureModel: model
]

{ #category : 'private - actions' }
StSpotter >> showPreview: aPresenter [

	previewContainer removeAll.
	(aPresenter isNil or: [ aPresenter isHeader ]) ifTrue: [ ^ self ].

	aPresenter model value ifNotNil: [ :value |
		value spotterPreview ifNotNil: [ :previewPresenter |
			previewContainer add: (previewPresenter
					 owner: self;
					 yourself) ] ]
]

{ #category : 'private - actions' }
StSpotter >> showSpinner [

	spinner isVisible ifTrue: [ ^ self ].
	self model schedule: [
		self defer: [ spinner show ]]
]

{ #category : 'processing' }
StSpotter >> startNewProcess [

	self keepLastSelectedEntry.
	self removeAll
]

{ #category : 'private' }
StSpotter >> startProcessing [
	"Start the process."

	self model schedule: [ 
		self allowUIToDraw.
		self model startProcessingOn: self
	]
]

{ #category : 'private' }
StSpotter >> stopProcessing [
	"Start the process."

	self model stopProcessing
]

{ #category : 'private' }
StSpotter >> transferFocusToResultList [
	| index |

	index := resultList selection selectedIndex + 1.
	self transferFocusToResultListAt: ((index > resultList items size)
		ifTrue: [ 1 ]
		ifFalse: [ index ])
]

{ #category : 'private' }
StSpotter >> transferFocusToResultListAt: index [

	resultList items isEmptyOrNil ifTrue: [ ^ self ].
	
	resultList 
		selectIndex: index;
		takeKeyboardFocus
]

{ #category : 'private' }
StSpotter >> transferFocusToResultListAtLast [ 

	self transferFocusToResultListAt: (resultList presenters size)
]

{ #category : 'private' }
StSpotter >> transferFocusToSearchTextArrowDown [
	| index |

	resultList items ifEmpty: [ ^ self ].

	index := resultList selection selectedIndex.
	index = resultList items size
		ifTrue: [ searchText takeKeyboardFocus ]
		ifFalse: [ resultList selectIndex: index + 1 scrollToSelection: true ]
]

{ #category : 'private' }
StSpotter >> transferFocusToSearchTextArrowUp [
	| index |

	resultList items ifEmpty: [ ^ self ].

	index := resultList selection selectedIndex.
	index  = 1
		ifTrue: [ searchText takeKeyboardFocus ]
		ifFalse: [ resultList selectIndex: index - 1 scrollToSelection: true ]
]

{ #category : 'private - actions' }
StSpotter >> tryDiveIn [
	| item |
	
	self model isNested ifTrue: [ ^ self ].
	item := resultList selectedItem.
	item ifNil: [ ^ self ].
	item isHeader ifFalse: [ ^ self ].
	item diveIn
]

{ #category : 'private - actions' }
StSpotter >> tryDiveOut [
	| item |
	
	self model isNested ifFalse: [ ^ self ].
	item := resultList selectedItem.
	item ifNil: [ ^ self ].
	item isHeader ifFalse: [ ^ self ].
	item diveOut
]

{ #category : 'initialization' }
StSpotter >> updatePresenter [

	self feedTip
]

{ #category : 'private - updating' }
StSpotter >> updateResultList: aCandidateLink [

	mutex critical: [ queue add: aCandidateLink ].
	lastUpdateTime ifNil: [ lastUpdateTime := Time millisecondClockValue ].
	(updating or: [ (Time millisecondClockValue - lastUpdateTime) < 50 ]) 
		ifTrue: [ ^ self ].
	
	self flushPendingUpdates
]

{ #category : 'private - updating' }
StSpotter >> updateResultProcessor: processor amount: amount [

	self defer: [ 
		categories 
			at: processor 
			ifPresent: [ :aPresenter | aPresenter finalAmount: amount ] ]
]

{ #category : 'private - updating' }
StSpotter >> updateSearch: aString [
	
	self model schedule: [
		self model 
			processSearch: aString 
			on: self ]
]

{ #category : 'private - updating' }
StSpotter >> updateSearchFromProcessor: aProcessor [

	searchText text: aProcessor query textInSearchBar.
	searchText cursorPositionIndex: searchText text size + 1.
]
