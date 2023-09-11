"
A playbook is a keeper of playgrounds (in a list). 
This works to enhance grouping (as playgrounds tends to accumulate).
"
Class {
	#name : #StPlaybook,
	#superclass : #StPlayground,
	#instVars : [
		'pageList',
		'pageListToolbar',
		'pages',
		'activating'
	],
	#category : #'NewTools-Playground-Playbook-View'
}

{ #category : #'private - commands' }
StPlaybook class >> baseToolbarCommands [

	^ { 
	StPlaybookNewPageCommand.
	StPlaybookPagesCommand.
	}
]

{ #category : #accessing }
StPlaybook class >> defaultTitle [

	^ 'Playbook'
]

{ #category : #'private - commands' }
StPlaybook class >> extendedToolbarCommands [

	^ #()
]

{ #category : #'world menu' }
StPlaybook class >> menuCommandOn: aBuilder [
	<worldMenu>
	
	(aBuilder item: #Playbook)
		parent: #InputOutput;
		action: [ StPlaybook open ];
		order: 1;
		keyText: 'o, p';
		help: 'A window used as a scratchpad area where fragments of Pharo code can be entered, stored, edited, and evaluated.';
		icon: (self iconNamed: #workspace)
]

{ #category : #'private - commands' }
StPlaybook class >> toolbarCommands [

	^ (self baseToolbarCommands, self extendedToolbarCommands) sorted: #order ascending
]

{ #category : #actions }
StPlaybook >> activateExistingPage: aPage [
	
	pageList selectItem: (pageList items detect: [ :each | each model = aPage ]).
	self loadPage: aPage.
	millerList takeKeyboardFocus
]

{ #category : #actions }
StPlaybook >> activatePage: aPage [

	"if page is already in list, select it"
	(pages includes: aPage) ifTrue: [ 
		self activateExistingPage: aPage.
		^ self ].

	self activatingDo: [
		self cleanEmptyPlaygrounds.
		aPage touch.
		pages add: aPage.
		self updatePresenter ]
]

{ #category : #actions }
StPlaybook >> activateSelectedPage [

	self activatingDo: [ 
		self loadPage: self selectedPage ]
]

{ #category : #private }
StPlaybook >> activatingDo: aBlock [
	| oldActivating |
	
	oldActivating := activating.
	activating := true.
	aBlock ensure: [ 
		activating := false ]
]

{ #category : #private }
StPlaybook >> addPageListToolbarCommandsTo: aGroup [

	self class toolbarCommands do: [ :each | 
		aGroup register: (each forSpecContext: self) ]
]

{ #category : #private }
StPlaybook >> cleanEmptyPlaygrounds [

	"'clean' empty playgrounds"
	(pages 
		select: [ :each | each isEmpty ])
		do: [ :each | pages remove: each ].
]

{ #category : #layout }
StPlaybook >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 250;
		add: (SpBoxLayout newTopToBottom 
			add: pageListToolbar expand: false;
			add: pageList;
			yourself);
		add: millerList;
		yourself
]

{ #category : #actions }
StPlaybook >> doAddNewPage [

	pages add: StPlaygroundPage new.
	self updatePresenter
]

{ #category : #actions }
StPlaybook >> doRemoveSelectedPage [

	pages remove: self selectedPage.
	pages 
		ifEmpty: [ self doAddNewPage ]
		ifNotEmpty: [ self updatePresenter ]
]

{ #category : #initialization }
StPlaybook >> initialize [

	activating := false.
	pages := OrderedCollection with: StPlaygroundPage new.
	super initialize
]

{ #category : #initialization }
StPlaybook >> initializePresenters [

	super initializePresenters.
	
	pageListToolbar := self newToolbar
		displayMode: self application toolbarDisplayMode;
		addStyle: 'stToolbar';
		fillWith: self pageListToolbarActions;
		yourself.
	
	pageList := self newComponentList
		activateOnSingleClick;
		contextMenu: [ self pageListActions asMenuPresenter ];
		contextKeyBindings: self pageListActions asKMCategory;
		whenActivatedDo: [ self activateSelectedPage ];
		yourself
]

{ #category : #'private - events' }
StPlaybook >> pageFlushed: ann [

	pageList selectedItem updatePresenter.
	"do not trigger an update (that will make me lose the cursor)"
	pageList disableActivationDuring: [ 
		self updatePresenter ]
]

{ #category : #private }
StPlaybook >> pageListActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (StPlaybookRemovePageCommand forSpecContext: self);
		yourself
]

{ #category : #private }
StPlaybook >> pageListToolbarActions [

	^ CmCommandGroup forSpec
		in: [ :this | self addPageListToolbarCommandsTo: this ];
		yourself
]

{ #category : #'private - events' }
StPlaybook >> pageLoaded: ann [
	| selectedItem |

	activating ifTrue: [ ^ self ].

	selectedItem := pageList selectedItem.
	ann page touch.
	pages 
		at: (pages indexOf: selectedItem model) 
		put: ann page.
	selectedItem model: ann page
]

{ #category : #private }
StPlaybook >> pages [

	^ pages
]

{ #category : #private }
StPlaybook >> pagesAsPresenters [

	^ self pages collect: [ :each | 
		self 
			instantiate: StPlaygroundPageSummaryPresenter
			on: each  ]
]

{ #category : #private }
StPlaybook >> prepareInspectorAsPlayground: inspector [
	
	inspector announcer
		when: StPlaygroundPageLoaded 
			send: #pageLoaded: 
			to: self;
		when: StPlaygroundPageFlushed
			send: #pageFlushed:
			to: self
]

{ #category : #private }
StPlaybook >> selectedPage [

	^ pageList selectedItem page
]

{ #category : #private }
StPlaybook >> sortFunction [

	^ [ :aPresenter | aPresenter model modificationTime ] descending
]

{ #category : #'private - stepping' }
StPlaybook >> startProcessing [

	super startProcessing.
	self updatePageList
]

{ #category : #'private - updating' }
StPlaybook >> updatePageList [

	pageList updateItemsKeepingSelection: (pageList items sort: self sortFunction)
]

{ #category : #initialization }
StPlaybook >> updatePresenter [

	pageList 
		presenters: (self pagesAsPresenters sort: self sortFunction);
		selectFirst.
	
	self loadPage: pageList selectedItem model
]
