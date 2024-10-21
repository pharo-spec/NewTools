"
I am a presenter to show saved pages from a playground. 
A playground saves (or tries to save) everything you will put in a playground and it will store in the playground cache to make it available later (or even outside the image).

I show a list and a preview of a page content, to allow users to chose a page to load.
"
Class {
	#name : 'StPlaygroundPagesPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'parent',
		'pageList',
		'pagePreview',
		'pageListPanel',
		'pagePreviewPanel',
		'loadPageAction'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'accessing' }
StPlaygroundPagesPresenter class >> defaultExtent [

	^ (700@400)
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter class >> defaultTitle [

	^ 'Pages'
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter class >> emptyMessage [

	^ 'There are no pages to list.'
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter class >> pages [

	
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter class >> unselectedMessage [

	^ 'Select a page to preview it.'
]

{ #category : 'layout' }
StPlaygroundPagesPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: self initialExtent x * 0.3;
		add: pageListPanel;
		add: pagePreviewPanel;
		yourself
]

{ #category : 'actions' }
StPlaygroundPagesPresenter >> doLoadPage [
	
	self loadSelectedPage
]

{ #category : 'actions' }
StPlaygroundPagesPresenter >> doLoadPageOnNewPlayground [
	| playground |
	
	(playground := StPlaygroundPresenter new) 
		loadPage: self selectedPage;
		open.
	self window close.
	playground takeKeyboardFocus 		
]

{ #category : 'initialization' }
StPlaygroundPagesPresenter >> initialExtent [
		
	^ self class defaultExtent
]

{ #category : 'initialization' }
StPlaygroundPagesPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		centeredRelativeToTopWindow;
		addButton: 'Close' do: [ :presenter |
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Load' do: [ :presenter |
			presenter triggerOkAction.
			self loadSelectedPage ]
]

{ #category : 'initialization' }
StPlaygroundPagesPresenter >> initializePresenters [

	(pageListPanel := self instantiate: StHeaderPanel)		
		number: 1;
		label: 'Pages';
		presenter: (pageList := self newComponentList
			presenters: self pagesAsPresenters;
			actions: self pagesActions;
			whenActivatedDo: [ self loadSelectedPage ];
			addShortcutWith: [ :action | action 
				shortcutKey: Character cr asKeyCombination; 
				action: [ self loadSelectedPage ] ];
			yourself).
		
	(pagePreviewPanel := self instantiate: StHeaderPanel)
		number: 2;
		label: 'Preview';
		presenter: (pagePreview := self newPresenterSelector
			when: [ :aPage | aPage isNotNil ] show: [ :aPage | 
				self newCode 
					editable: false;
					text: aPage contents ];
			when: [ :aPage | aPage isNil ] show: [ 
				pageList items
					ifNotEmpty: [ self class unselectedMessage asPresenter ]
					ifEmpty: [ self class emptyMessage asPresenter ] ];
			yourself).
	
	pageList transmitTo: pagePreview.
	
	pageList items 
		ifNotEmpty: [ pageList selectIndex: 1 ]
		ifEmpty: [ pagePreview updatePresenter ]
]

{ #category : 'initialization' }
StPlaygroundPagesPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self class defaultTitle;
		initialExtent: self initialExtent;
		whenOpenedDo: [ pageList takeKeyboardFocus ]
]

{ #category : 'actions' }
StPlaygroundPagesPresenter >> loadPage: aPage [

	self window close.
	loadPageAction ifNotNil: [ 
		loadPageAction value: aPage ]
]

{ #category : 'actions' }
StPlaygroundPagesPresenter >> loadSelectedPage [

	self loadPage: self selectedPage
]

{ #category : 'events' }
StPlaygroundPagesPresenter >> onLoadPage: aBlock [

	loadPageAction := aBlock
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter >> pages [
	
	^ ((StPlaygroundPresenter cacheDirectory allChildrenMatching: '*.ph')
		sorted: #modificationTime descending)
		collect: [ :each | StPlaygroundPage fromReference: each ]
]

{ #category : 'private' }
StPlaygroundPagesPresenter >> pagesActions [

	^ SpActionGroup new
		register: (StPlaygroundLoadPageCommand forSpecContext: self);
		register: (StPlaygroundLoadPageOnNewPlaygroundCommand forSpecContext: self);
		yourself
]

{ #category : 'initialization' }
StPlaygroundPagesPresenter >> pagesAsPresenters [

	^ self pages collect: [ :each | 
		self 
			instantiate: StPlaygroundPageSummaryPresenter
			on: each  ]
]

{ #category : 'private' }
StPlaygroundPagesPresenter >> parent [

	^ parent
]

{ #category : 'accessing' }
StPlaygroundPagesPresenter >> selectedPage [

	^ pageList selection selectedItem page
]

{ #category : 'accessing - model' }
StPlaygroundPagesPresenter >> setModelBeforeInitialization: aPlayground [

	parent := aPlayground
]
