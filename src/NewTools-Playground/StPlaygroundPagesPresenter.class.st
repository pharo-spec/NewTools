"
I am a presenter to show saved pages from a playground. 
A playground saves (or tries to save) everything you will put in a playground and it will store in the playground cache to make it available later (or even outside the image).

I show a list and a preview of a page content, to allow users to chose a page to load.
"
Class {
	#name : #StPlaygroundPagesPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'pageList',
		'pagePreview'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlaygroundPagesPresenter class >> defaultExtent [

	^ 700@400
]

{ #category : #specs }
StPlaygroundPagesPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add: #pageList;
		add: #pagePreview;
		yourself
]

{ #category : #accessing }
StPlaygroundPagesPresenter class >> defaultTitle [

	^ 'Pages'
]

{ #category : #accessing }
StPlaygroundPagesPresenter class >> emptyMessage [

	^ 'There are no pages to list.'
]

{ #category : #accessing }
StPlaygroundPagesPresenter class >> pages [

	
]

{ #category : #accessing }
StPlaygroundPagesPresenter class >> unselectedMessage [

	^ 'Select a page to preview it.'
]

{ #category : #initialization }
StPlaygroundPagesPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		centeredRelativeToTopWindow;
		addButton: 'Close' do: [ :presenter |
			presenter triggerOkAction.
			presenter close ]
]

{ #category : #initialization }
StPlaygroundPagesPresenter >> initializePresenters [

	pageList := self newComponentList
		presenters: self pagesAsPresenters;
		yourself.
		
	pagePreview := self newPresenterSelector
		when: [ :aPage | aPage notNil ] show: [ :aPage | 
			self newCode 
				editable: false;
				text: aPage contents ];
		when: [ :aPage | aPage isNil ] show: [ 
			pageList items
				ifNotEmpty: [ self class unselectedMessage asPresenter ]
				ifEmpty: [ self class emptyMessage asPresenter ] ];
		updatePresenter.
	
	pageList transmitTo: pagePreview.
	
	pageList items ifNotEmpty: [ 
		pageList selectIndex: 1 ]
]

{ #category : #initialization }
StPlaygroundPagesPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		initialExtent: self class defaultExtent;
		whenOpenedDo: [ pageList takeKeyboardFocus ]
]

{ #category : #accessing }
StPlaygroundPagesPresenter >> pages [
	
	^ (StPlayground cacheDirectory allChildrenMatching: '*.ph')
		sorted: [ :a :b | a creationTime > b creationTime ]
]

{ #category : #initialization }
StPlaygroundPagesPresenter >> pagesAsPresenters [

	^ self pages collect: [ :each | 
		self 
			instantiate: SpPlaygroundPageSummaryPresenter
			on: each  ]
]
