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

	pageList := self newComponentList.
	pagePreview := self newPresenterSelector
		when: [ :aPage | aPage notNil ] show: [ :aPage | 
			self newCode text: aPage contents ];
		when: [ :aPage | aPage isNil ] show: [ 
			pageList items
				ifNotEmpty: [ self class unselectedMessage asPresenter ]
				ifEmpty: [ self class emptyMessage asPresenter ] ];
		updatePresenter.
	
	pageList transmitTo: pagePreview.
	
	self updatePresenter.
	
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
			instantiate: SpPlaygroundPagePresenter
			on: each  ]
]

{ #category : #initialization }
StPlaygroundPagesPresenter >> updatePresenter [

	pageList items: self pagesAsPresenters
]
