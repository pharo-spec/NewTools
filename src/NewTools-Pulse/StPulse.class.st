"
When exploring the system, is useful to have a single entry point that will allow users to search for different component of the system.
Spotter provides such entry point and is usually available by pressing <meta+enter>.

Pulse is a remake of Spotter, a front-end to show the result of different processors that provide results. Those processors can be configured in different ways and will provide different access options.

The idea is to divide the old Spotter in 3 tabs:
•  Environment for classes, methods, packages
•  Windows for every open window in the image
•  Tools for menu items

Some known processors and options are (You can see most of the information needed in the help icon when you open the tool):

Classes processor:
•	Type #classes in the search bar
•	Press <meta+b>
Implementors processor:
•	Type #implementors in the search bar
•	Press <meta+m>

---

Right now Pulse pulls the first 25 results it gets, getting the first 3 via events so the user doesn't have to wait for the full search to be over to find the first results, which speeds the user experience.

Any time you open either a class, a method or a package (anything that is in the environment tab) it is stored as a HistoryEntry version of itself, which stores either its contents serialized to a string or in the case of the package it stores the package name and when its pulled it makes the search. This was done to evade hard references, and every HistoryEntry are stored in a memory circular logger that cleans itself from any nil entry or any entry with a nil content.

The UI works with a single lists whose context is defined by the page of the paginator that is opened at the moment: When you either change tabs or write, it sends a search (there is a service running every 50 milliseconds which is the one in charge of behaving differently depending on what part of the search is or even if it is or not searching at the moment, StPulse >> processSearch has all the logic and is the method called by the service's step) and there is an outside of service search done when changing tabs.


"
Class {
	#name : 'StPulse',
	#superclass : 'StPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'emptyPresenter',
		'searchPresenter',
		'listLabelPresenter',
		'listCounterPresenter',
		'listTitleLayout',
		'findAllButton',
		'listPresenter',
		'previewContainer',
		'popover',
		'buttonsToolbar',
		'spinner',
		'paginator',
		'windowsContext',
		'toolsContext',
		'environmentContext',
		'service',
		'searchWorker',
		'updateWorker',
		'mutex',
		'waitingSearchText',
		'lastSearchText',
		'numCandidatesAdded',
		'candidatesAddedList',
		'candidatesFullSearchList',
		'doFullSearchNext'
	],
	#classVars : [
		'Activated',
		'History',
		'InsertsSelection',
		'PreviewVisible'
	],
	#classInstVars : [
		'pulse'
	],
	#category : 'NewTools-Pulse-View',
	#package : 'NewTools-Pulse',
	#tag : 'View'
}

{ #category : 'private - compatibility' }
StPulse class >> activated [
"It is used to be able to use StSpotter (old spotter) while StPulse is being tested. This whole protocol and all its methods should be removed when it eventually replaces StSpotter, and ToolShortcutsCategory >> openPulseEnvironment should also be refactored. Read more on that method."
	^ Activated ifNil: [ 
		Activated := true ]
]

{ #category : 'private - compatibility' }
StPulse class >> activatedOff [
"It is used to be able to use StSpotter (old spotter) while StPulse is being tested. This whole protocol and all its methods should be removed when it eventually replaces StSpotter, and ToolShortcutsCategory >> openPulseEnvironment should also be refactored. Read more on that method."
	<script>
	Activated := false
]

{ #category : 'private - compatibility' }
StPulse class >> activatedOn [
"It is used to be able to use StSpotter (old spotter) while StPulse is being tested. This whole protocol and all its methods should be removed when it eventually replaces StSpotter, and ToolShortcutsCategory >> openPulseEnvironment should also be refactored. Read more on that method."
	<script>
	Activated := true
]

{ #category : 'world menu' }
StPulse class >> candidateAdded: ann [

	pulse ifNil: [ ^ self ].
	pulse candidateAdded: ann
]

{ #category : 'accessing' }
StPulse class >> defaultInitialPageIndex [
"This number represents the page index that a StPulse should start with"
"1 = Environment | 2 = Windows | 3 = Commands"
	^ 1
]

{ #category : 'accessing' }
StPulse class >> defaultPreferredExtent [

	^ 850@700
]

{ #category : 'accessing' }
StPulse class >> hidePreview [
	<script>

	PreviewVisible := false
]

{ #category : 'accessing' }
StPulse class >> historize: aStEntry [

	self history add: aStEntry
]

{ #category : 'accessing' }
StPulse class >> history [

	^ History ifNil: [ 
		History := StPulseHistoryCollection new ]
]

{ #category : 'settings' }
StPulse class >> insertsSelection [

	^ InsertsSelection ifNil: [ 
		InsertsSelection := false ]
]

{ #category : 'settings' }
StPulse class >> insertsSelection: aBoolean [

	InsertsSelection := aBoolean
]

{ #category : 'accessing' }
StPulse class >> insertsSelectionOff [

	<script>
	InsertsSelection := false
]

{ #category : 'accessing' }
StPulse class >> insertsSelectionOn [

	<script>
	InsertsSelection := true
]

{ #category : 'testing' }
StPulse class >> isShowingPreview [

	^ PreviewVisible ifNil: 
		[ PreviewVisible := true ]
]

{ #category : 'accessing' }
StPulse class >> maxCandidatesAdded [
"Maximum amount of candidates added from events before of full update. This is done so when looking for
something that has a small amount of results, it gives you the results it finds before looking in the whole system. 
For eg. StObjectTranscriptPresenter --> 2 results
Without this, this search doesn't give you those 2 results before it looks in the whole system."
	^ 3
]

{ #category : 'instance creation' }
StPulse class >> newWithText: aText [

	self reset.
	pulse := self new.
	pulse searchPresenter text: aText.
	^ pulse 
]

{ #category : 'instance creation' }
StPulse class >> open [

	<script>
	^ self openWithText: ''
]

{ #category : 'instance creation' }
StPulse class >> openWithText: aText [
"If a Spotter is already open, it closes itself and opens the Finder instead.  
 Otherwise, it initializes a new Spotter. The purpose of this is so users can 
 press 'shift+enter' inside the Spotter to open the Finder."
   
	^ self openWithText: aText page: self defaultInitialPageIndex
]

{ #category : 'instance creation' }
StPulse class >> openWithText: aText page: index [
"If a Spotter is already open, it closes itself and opens the Finder instead.  
 Otherwise, it initializes a new Spotter. The purpose of this is so users can 
 press 'shift+enter' inside the Spotter to open the Finder."
   | searchText |

	pulse ifNotNil: [
		pulse isVisible ifTrue: [
			searchText := pulse searchPresenter text.
			self reset.
			^ StFinderPresenter openWithText: searchText ] ].
	
	pulse := self newWithText: aText asString.
	pulse selectPage: index.
	^ pulse openModal
]

{ #category : 'instance creation' }
StPulse class >> openWithTextOnCommands: aText [

	^ self openWithText: aText page: 3
]

{ #category : 'instance creation' }
StPulse class >> openWithTextOnEnvironment: aText [

	^ self openWithText: aText page: 1
]

{ #category : 'instance creation' }
StPulse class >> openWithTextOnWindows: aText [

	^ self openWithText: aText page: 2
]

{ #category : 'settings' }
StPulse class >> previewVisible [

	^ PreviewVisible
]

{ #category : 'settings' }
StPulse class >> previewVisible: aBoolean [
	
	PreviewVisible := aBoolean
]

{ #category : 'private' }
StPulse class >> pulse [

	^ pulse
]

{ #category : 'tools registry' }
StPulse class >> registerToolsOn: registry [
	"self registerToolsOn: Smalltalk tools"

	registry register: self as: #pulse
]

{ #category : 'class initialization' }
StPulse class >> reset [
	
	pulse ifNotNil: [ 
		pulse withWindowDo: [ :window | window close ].
		pulse := nil ]
]

{ #category : 'settings' }
StPulse class >> resetHistory [

	<script>
	History := nil
]

{ #category : 'settings' }
StPulse class >> resetSize [

	<script>
	self preferredExtent: nil
]

{ #category : 'settings' }
StPulse class >> settingsOn: aBuilder [
<systemsettings>

	(aBuilder group: #pulse)
		parent: #tools;
		label: 'Pulse';
		target: self;
		description: 'Pulse configuration'.

	(aBuilder setting: #previewVisible)
		parent: #pulse;
		default: true;
		target: self;
		description: 'Show the preview panel';
		label: 'Show Preview Panel'.
		
	(aBuilder setting: #insertsSelection)
		parent: #pulse;
		default: false;
		target: self;
		description: 'When opening pulse, insert the selected content into the search bar';
		label: 'Inserts Selection'.
		
	(aBuilder button: #resetHistory)
		parent: #pulse;
		target: self;
		description: 'Resets the history of environmment entries of Pulse';
		label: 'Reset history';
		buttonLabel: 'Reset'.
		
	(aBuilder button: #resetSize)
		parent: #pulse;
		description: 'Resets the stored size of Pulse, which can be changed at any time and will be remembered';
		label: 'Reset size';
		buttonLabel: 'Reset'
]

{ #category : 'accessing' }
StPulse class >> showPreview [
	<script>
	
	PreviewVisible := true
]

{ #category : 'private' }
StPulse class >> tips [

	^ {
		'arrows' -> 'navigation shortkeys'.
		'<ctrl + arrows>' -> 'navigation on search bar'.
		'<ctrl + arrow down>' -> 'makes a full search' .
		'<meta+b>'  -> 'filters for Classes' .
		'<meta+m>' -> 'filters for Implementors' .
		'<meta+p>' -> 'filters for Packages' .
		'you can resize the window' -> 'the size will be saved' .
		'settings icon' -> 'history, size and insertSelection' .
		'<shift + enter>' -> 'opens Pulse on Environment' .
		'<shift + meta + enter>' -> 'opens Pulse on Commands' .
		'<shift + alt + enter>' -> 'opens Pulse on Windows' .
		'<shift + enter> while on Pulse' -> 'opens Finder' 
	}
]

{ #category : 'private' }
StPulse class >> windowClosed [

	pulse := nil
]

{ #category : 'private - actions' }
StPulse >> acceptSelection [

	self withWindowDo: [ :aWindow | aWindow close ].
	
	listPresenter selectedItem
		ifNotNil: [ :anEntry |
			| historyEntry |
			(historyEntry := anEntry asHistoryEntry)
				ifNotNil: [ self historize: historyEntry ].
			anEntry accept: self ]
]

{ #category : 'initialization' }
StPulse >> addKeyboardBehavior: aPresenter [

	aPresenter 
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowUp asKeyCombination;
			action: [ self giveFocusToSearchTextArrowUp ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowDown asKeyCombination;
			action: [ self giveFocusToSearchTextArrowDown ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowLeft asKeyCombination;
			action: [ self giveFocusToPreviousResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowRight asKeyCombination;
			action: [ self giveFocusToNextResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey right asKeyCombination actionModifier;
			action: [ self giveFocusToNextResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey left asKeyCombination actionModifier;
			action: [ self giveFocusToPreviousResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey down asKeyCombination actionModifier;
			action: [ self findAllButtonAction ] ].
	
	aPresenter eventHandler whenKeyDownDo: [ :anEvent | 
			"0 = Left Control | 28 = Left Arrow | 29 = Right Arrow | 30 = Arrow up | 31 = Arrow down"
			(#(0 28 29 30 31) includes: anEvent keyValue )
				ifFalse:  [ searchPresenter takeKeyboardFocus ] ]
]

{ #category : 'initialization' }
StPulse >> addPreviewPanelTo: contentsLayout [

	contentsLayout 	add: (previewContainer := 
		SpBoxLayout newTopToBottom).
	listPresenter whenSelectionChangedDo: [ :selection | 
		self showPreview: selection selectedItem ]
]

{ #category : 'initialization' }
StPulse >> addProcessors: aWindowPresenter [

	(self model processorsForContext: self environmentContext) do: [ :each | 
		each new
		installKeymappingsOn: aWindowPresenter
			onExecution: [ :aProcessor | self updateSearchFromProcessor: aProcessor ] ].
	
	(self model processorsForContext: self windowsContext) do: [ :each | 
		each new
		installKeymappingsOn: aWindowPresenter
			onExecution: [ :aProcessor | self updateSearchFromProcessor: aProcessor ] ].
		
	(self model processorsForContext: self toolsContext) do: [ :each | 
		each new
		installKeymappingsOn: aWindowPresenter
			onExecution: [ :aProcessor | self updateSearchFromProcessor: aProcessor ] ]
]

{ #category : 'private - accessing' }
StPulse >> addToPaginator: aPresenter [

	paginator addPage: aPresenter
]

{ #category : 'private - actions' }
StPulse >> calculateListCounterPresenter [

	| selectedIndex |
	selectedIndex := listPresenter selectedIndex.
	(selectedIndex < 10 and: [ listPresenter items size > 10 ])
		ifTrue: [ selectedIndex := '0', (selectedIndex asString) ].
	listCounterPresenter label:
		selectedIndex asString,
		'/',
		listPresenter items size asString
]

{ #category : 'private - updating' }
StPulse >> candidateAdded: aCandidate [
	
	self mutex critical: [   
		numCandidatesAdded >= self class maxCandidatesAdded
			ifTrue: [ ^ self ]. 
		numCandidatesAdded := numCandidatesAdded + 1.
		candidatesAddedList add: aCandidate ]
]

{ #category : 'initialization' }
StPulse >> connectPresenters [

	searchPresenter 
		whenSubmitDo: [ :aString | self acceptSelection ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey down asKeyCombination;
			action: [ self giveFocusToResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey right asKeyCombination actionModifier;
			action: [ self giveFocusToNextResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey left asKeyCombination actionModifier;
			action: [ self giveFocusToPreviousResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowUp asKeyCombination;
			action: [ self giveFocusToResultListAtLast ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey down asKeyCombination actionModifier;
			action: [ self findAllButtonAction ] ].
	
	listPresenter 
		whenActivatedDo: [ self acceptSelection ];
		whenSelectionChangedDo:[ self calculateListCounterPresenter ].
	
	self addKeyboardBehavior: listPresenter.
	
	paginator whenSelectedPageChangedDo: [ :newValue |
		self application defer: [ 
			self updateActivePresenter: newValue ] ]
]

{ #category : 'api - focus' }
StPulse >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
StPulse >> defaultLayout [
    | contentsLayout result |
	"Spinner should always be added after findAllButtonLayout or the invisible presenter findAllButtonLayout uses will cover spinner"
	result := SpOverlayLayout new
		addOverlay: spinner withConstraints: [ :c | c vAlignEnd; hAlignStart ];
		addOverlay: buttonsToolbar withConstraints: [ :c | c vAlignEnd ; hAlignEnd ];
		addOverlay: emptyPresenter withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
		child: (SpBoxLayout newTopToBottom 
			add: searchPresenter expand: false;
			add: (contentsLayout := SpBoxLayout newLeftToRight
				add: (SpBoxLayout newTopToBottom
					add: listTitleLayout expand: false;
					add: listPresenter;
					yourself);
				yourself);
			add: (SpBoxLayout newTopToBottom 
					hAlignCenter;
					vAlignStart;
					add: paginator;
					yourself)
				expand: false;
			yourself);
		yourself.
		
	self isShowingPreview ifTrue: [ 
		self addPreviewPanelTo: contentsLayout ].
    ^ result
]

{ #category : 'private - actions' }
StPulse >> doFullSearch: aString [
	
	self owner 
		ifNil: [ ^ self ].
	self searchWorker purge.
	self searchWorker schedule: [ 
		candidatesFullSearchList := self model 
			allCandidatesFor: aString 
			inContext: self selectedContext ]
]

{ #category : 'private - actions' }
StPulse >> doSearch: aString [
	
	self owner 
		ifNil: [ ^ self ].
	numCandidatesAdded := 0.
	self searchWorker purge.
	self searchWorker schedule: [ 
		candidatesFullSearchList := self model 
			candidatesFor: aString 
			inContext: self selectedContext ]
]

{ #category : 'private - actions' }
StPulse >> doSearchOutsideOfService [

	lastSearchText := searchPresenter text. 
	waitingSearchText := searchPresenter text.
	self ensurePulseService.
	self doSearch: waitingSearchText.
	self processFullAddedCandidates
]

{ #category : 'private - service' }
StPulse >> ensurePulseService [
		
	service ifNotNil: [ 
		service isRunning ifFalse: [ service restart ].
		^ service ].
	
	service := TKTParameterizableService new.
	service name: 'Pulse service: ', UUID new asString.
	service stepDelay: 200 milliSeconds.
	service step: [ self processSearch ].
	service start.
	
	^ service
]

{ #category : 'private - accessing' }
StPulse >> environmentContext [

	^ environmentContext ifNil: [ 
		environmentContext := StPulseSearchContext searchEnvironment ]
]

{ #category : 'private - actions' }
StPulse >> findAllButtonAction [

	doFullSearchNext := true. 
	self defaultKeyboardFocus takeKeyboardFocus
]

{ #category : 'private - actions' }
StPulse >> giveFocusToNextResultList [
"If selectedPage = last page select first, else select selectedPage + 1"
	paginator selectedPage = paginator pages size
		ifTrue: [ paginator selectPage: 1 ]
		ifFalse: [ paginator selectPage: paginator selectedPage + 1 ]
]

{ #category : 'private - actions' }
StPulse >> giveFocusToPreviousResultList [
"If selectedPage = first, select last. Else, select selectedPage - 1"
	paginator selectedPage = 1
		ifTrue: [ paginator selectPage: paginator pages size ]
		ifFalse: [ paginator selectPage: paginator selectedPage - 1 ]
]

{ #category : 'private - actions' }
StPulse >> giveFocusToResultList [

	| lastCharacter |
	lastCharacter := searchPresenter text size + 1.
	searchPresenter selectionInterval: (lastCharacter to: lastCharacter).
	
	listPresenter takeKeyboardFocus
]

{ #category : 'private - actions' }
StPulse >> giveFocusToResultListAtLast [
	

	listPresenter selectIndex:  listPresenter items size scrollToSelection: true.
	listPresenter takeKeyboardFocus
]

{ #category : 'private - actions' }
StPulse >> giveFocusToSearchTextArrowDown [

	| index first |
	
	listPresenter items ifEmpty: [ ^ self ].
	first := 1.
	index := listPresenter selectedIndex.
	index  = listPresenter items size
		ifTrue: [ listPresenter selectIndex: first scrollToSelection: true ]
		ifFalse: [ listPresenter selectIndex: index + 1 scrollToSelection: true ].
		
	listPresenter takeKeyboardFocus
]

{ #category : 'private - actions' }
StPulse >> giveFocusToSearchTextArrowUp [

	| index |

	listPresenter items ifEmpty: [ 
		searchPresenter takeKeyboardFocus.
		^ self ].

	index := listPresenter selectedIndex.
	index = 1
		ifTrue: [ searchPresenter takeKeyboardFocus ]
		ifFalse: [ listPresenter selectIndex: index - 1 scrollToSelection: true ]
]

{ #category : 'private - actions' }
StPulse >> hideSpinner [

	spinner isVisible ifFalse: [ ^ self ].
	self application defer: [ spinner hide ]
]

{ #category : 'private - actions' }
StPulse >> historize: aStEntry [

	self class historize: aStEntry
]

{ #category : 'private - accessing' }
StPulse >> historyEntries [

	^ self class history entries
]

{ #category : 'initialization' }
StPulse >> initialize [
	
	self setModelBeforeInitialization: (StPulseModel new
		whenCandidateAddedDo: [ :aCandidate | self candidateAdded: aCandidate ];
		yourself).
	super initialize.
	numCandidatesAdded := 0.
	candidatesAddedList := OrderedCollection new.
	doFullSearchNext := false
]

{ #category : 'initialization' }
StPulse >> initializeButtons [

	| helpButton settingsButton |

	findAllButton := self newButton
		addStyle: 'small';
		addStyle: 'stPulseButton';
		icon: (self iconNamed: #glamorousDown);
		action: [ self findAllButtonAction ];
		help: 'Gives you all the results of a search. Normal searchs only give you the first 25';
		yourself.

	helpButton := self newButton
		addStyle: 'small';
		addStyle: 'stPulseButton';
		icon: (self iconNamed: #help);
		action: [ self showPopover: helpButton ];
		help: 'Open popover with tips for StPulse'.

	settingsButton := self newButton
		addStyle: 'small';
		addStyle: 'stPulseButton';
		icon: (self application iconNamed: #configuration);
		action: [ 
			self defaultKeyboardFocus takeKeyboardFocus.
			self openSettingsBrowser ];
		help: 'Open settings browser to configure StPulse'.
	self addKeyboardBehavior: findAllButton.
	self addKeyboardBehavior: helpButton.
	self addKeyboardBehavior: settingsButton.
	buttonsToolbar := self newPresenter
		layout: (SpBoxLayout newLeftToRight
			add: settingsButton expand: false;
			add: helpButton expand: false;
			yourself)
]

{ #category : 'initialization' }
StPulse >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter closeOnBackdropClick: true
]

{ #category : 'initialization' }
StPulse >> initializeListLabel [

	listLabelPresenter := self newLabel
		addStyle: 'stPulseLabel';
		yourself.
		
	listCounterPresenter := self newLabel
		addStyle: 'dim';
		yourself.
	
	listTitleLayout := self newPresenter
		layout: (SpBoxLayout newLeftToRight 
			add: listLabelPresenter expand: true;
			add: listCounterPresenter expand: false;
			add: findAllButton expand: false;
			yourself);
		yourself
]

{ #category : 'initialization' }
StPulse >> initializePaginator [

	paginator := SpPaginatorPresenter new
		addStyle: 'stPulsePaginator';
		visiblePages: 1;
		withoutResizingEdges;
		yourself.

	self addToPaginator: self environmentContext.
	self addToPaginator: self windowsContext.
	self addToPaginator: self toolsContext
]

{ #category : 'initialization' }
StPulse >> initializePresenters [

	self addStyle: 'stPulse'.
	self initializePaginator.
	self initializeButtons.
	self initializeListLabel.
	
	spinner := (self instantiate: StPulseLoadingPresenter)
		addStyle: 'stPulseSpinner';
		yourself.
	spinner hide.
	
	emptyPresenter := self newLabel 
		label: 'No results yet...';
		visible: false;
		yourself.

	searchPresenter := self newSearchInput
		addStyle: 'stPulseSearch';
		yourself.

	listPresenter := self newEasyListView
		addStyle: 'stPulseList';
		rowPresenterClass: StPulseRowPresenter;
		yourself
]

{ #category : 'initialization' }
StPulse >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Pulse';
		withoutDecorations;
		windowIcon: self windowIcon;
		initialExtent: self preferredExtent;
		"Force focus to be on the defaultKeyboardFocus presenter. This is needed because for some reason, the windows is trying to assign the focus before the DOM is completed, which in turn makes it so the focus is taken after being assigned"
		whenOpenedDo: [ self defaultKeyboardFocus takeKeyboardFocus ];
		whenClosedDo: [ 
			self windowClosed. 
			self class windowClosed ];
		whenResizingDo: [ :ann | self preferredExtent: ann newSize ];
		centered.
	self addProcessors: aWindowPresenter
]

{ #category : 'testing' }
StPulse >> isShowingPreview [

	^ self class isShowingPreview
]

{ #category : 'private' }
StPulse >> listPresenter [

	^ listPresenter
]

{ #category : 'private' }
StPulse >> mutex [ 

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private - actions' }
StPulse >> openSettingsBrowser [

	SettingBrowser new
		rootNodes:
		(SettingBrowser currentTree nodeNamed: #pulse) allChildren;
		open
]

{ #category : 'private - accessing' }
StPulse >> previewContainer [

	^ previewContainer
]

{ #category : 'private - service' }
StPulse >> processAddedCandidates [
	"If its empty, the history is put in its place. That's why it is not checked."
	| candidates |
	
	candidatesAddedList ifEmpty: [ ^ self ].
	searchPresenter text ifEmpty: [ ^ self ].
	candidates := candidatesAddedList asArray.
	candidatesAddedList removeAll.
	self updateResultListWith: candidates
]

{ #category : 'private - service' }
StPulse >> processFullAddedCandidates [
"We candidatesAddedList removeAll to evade it updating the list again after the whole result is added to the list"
	| candidates |
	candidatesFullSearchList ifNil: [ ^ self ].
	candidatesAddedList removeAll.
	candidates := candidatesFullSearchList.
	candidatesFullSearchList := nil.
	self hideSpinner.
	self updateResultListWith: candidates
]

{ #category : 'private - service' }
StPulse >> processSearch [

	waitingSearchText := searchPresenter text.
	spinner isVisible ifTrue: [ spinner updateStep ].
	
	doFullSearchNext
		ifTrue: [
			doFullSearchNext := false.
			self showSpinner.
			^ self doFullSearch: waitingSearchText ].

	waitingSearchText = lastSearchText 
		ifTrue: [
			candidatesFullSearchList
				ifNil: [ self processAddedCandidates ]
				ifNotNil: [ self processFullAddedCandidates ] ]
		ifFalse: [
			self showSpinner.
			lastSearchText := waitingSearchText.
			self doSearch: waitingSearchText ]
]

{ #category : 'private - accessing' }
StPulse >> searchPresenter [

	^ searchPresenter
]

{ #category : 'private' }
StPulse >> searchWorker [ 
		
	searchWorker ifNil: [ 
	searchWorker := TKTWorker new  
		name: 'StPulse search worker: ', UUID new asString ; 
		start ].
	^ searchWorker ensureIsWorking
]

{ #category : 'private' }
StPulse >> selectPage: index [

	paginator selectPage: index
]

{ #category : 'private - accessing' }
StPulse >> selectedContext [

	^ paginator pages at: paginator selectedPage
]

{ #category : 'private - actions' }
StPulse >> showPopover: aPresenter [
	
	popover ifNotNil: [ popover dismiss ].
	(popover := self newPopover)
		relativeTo: aPresenter ;
		bePositionTop ;
		presenter: (SpPresenter new
			addStyle: 'stPulseHelp';
			layout: (SpGridLayout new
				beColumnNotHomogeneous ;
				column: 2 expand: false ;
				build: [ :builder | self class tips do: [ :each |
						builder add: each key ; add: each value ; nextRow ] ]
				yourself) ;
			yourself) ;
		popup
]

{ #category : 'private - actions' }
StPulse >> showPreview: aPresenter [

	previewContainer removeAll.
	aPresenter ifNil: [ ^ self ].
	aPresenter spotterPreview ifNotNil: [ :previewPresenter |
		self addKeyboardBehavior: previewPresenter. 
		previewContainer add: (previewPresenter
			addStyle: 'stPulsePreview' ;
			owner: self;
			yourself) ] 
]

{ #category : 'private - actions' }
StPulse >> showSpinner [

	spinner isVisible ifTrue: [ ^ self ].
	self application defer: [  
		spinner reset.
		spinner show ]
]

{ #category : 'private - accessing' }
StPulse >> toolsContext [

	^ toolsContext ifNil: [ 
		toolsContext := StPulseSearchContext searchTools ]
]

{ #category : 'private - updating' }
StPulse >> updateActivePresenter: newValue [		
		
	self updateListLabel.
	self updateSearchPlaceHolder.
	self doSearchOutsideOfService
]

{ #category : 'private - updating' }
StPulse >> updateListLabel [
"1 = Environment page, 2 = Windows page, 3 = Commands page"
	| index |
	listLabelPresenter ifNil: [ ^ self ].
	index := paginator selectedPage. 
	index = 1 ifTrue: [
		listLabelPresenter label: 'Environment'.
			^ self ].
	index = 2 ifTrue: [
		listLabelPresenter label: 'Windows'.
			^ self ].
	index = 3 ifTrue: [ 
		listLabelPresenter label: 'Commands'. 
			^ self].
	^ self
]

{ #category : 'initialization' }
StPulse >> updatePresenter [

	super updatePresenter
]

{ #category : 'private - updating' }
StPulse >> updateResultListWith: aCollection [
	"use defer to ensure UI loop" 
	self updateWorker schedule: [ 
		self application defer: [
				| list |
				list := (
					aCollection isEmpty 
					and: [ searchPresenter text isEmpty 
					and: self selectedContext = environmentContext ] )
		 	 	 		ifTrue: [ 	
								self hideSpinner. 
								self historyEntries ]
						ifFalse: [ aCollection ].
				emptyPresenter visible: list isEmpty.
				listPresenter disableActivationDuring: [
					listPresenter items: list.
					self calculateListCounterPresenter ].
				list isNotEmpty
					ifTrue: [ listPresenter selectFirst ] ] ]
]

{ #category : 'private - updating' }
StPulse >> updateSearchFromProcessor: aProcessor [

	searchPresenter text: aProcessor query textInSearchBar.
	searchPresenter cursorPositionIndex: searchPresenter text size + 1.
	paginator selectPage: (paginator pages indexOf: environmentContext)
]

{ #category : 'private - updating' }
StPulse >> updateSearchPlaceHolder [

	searchPresenter placeholder: self selectedContext searchPlaceholder
]

{ #category : 'private' }
StPulse >> updateWorker [ 
		
	updateWorker ifNil: [ 
	updateWorker := TKTWorker new  
		name: 'StPulse update worker: ', UUID new asString ; 
		start ].
	^ updateWorker ensureIsWorking
]

{ #category : 'visiting' }
StPulse >> visitClassEntry: aClassEntry [ 

	aClassEntry content ifNil: [ ^ self ].
	self systemNavigation browse: aClassEntry content
]

{ #category : 'visiting' }
StPulse >> visitMenuEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'visiting' }
StPulse >> visitMethodEntry: aClassEntry [ 

	aClassEntry content ifNil: [ ^ self ].
	self systemNavigation browse: aClassEntry content
]

{ #category : 'visiting' }
StPulse >> visitWindowEntry: aWindowEntry [
	
	aWindowEntry content stActDefault
]

{ #category : 'private - accessing' }
StPulse >> windowClosed [

	service ifNotNil: [ service stop ].
	updateWorker ifNotNil: [ updateWorker stop ].
	searchWorker ifNotNil: [ searchWorker stop ].
	service := nil.
	updateWorker := nil.
	searchWorker := nil
]

{ #category : 'private - accessing' }
StPulse >> windowsContext [

	^ windowsContext ifNil: [ 
		windowsContext := StPulseSearchContext searchEditors ]
]
