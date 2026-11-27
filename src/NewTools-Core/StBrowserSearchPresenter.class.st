"
Provides a searchable list of classes, and options to configure the search mode (substring search (default), regular expression, exact). The search mode can be combined with case-sensitiveness.

Multiple classes can be selected if the #multipleSelection option is enabled.

A dialog can remember its search: after `rememberSearchAs: #class` it starts with the last search accepted in a dialog remembering its search as #class, and remembers its own search when it is accepted. Each key (#class, #package...) has its own last search, kept on the class side (`lastSearchAs:`).
"
Class {
	#name : 'StBrowserSearchPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'items',
		'itemsList',
		'searchField',
		'searchOptions',
		'searchKey'
	],
	#classInstVars : [
		'lastSearches'
	],
	#category : 'NewTools-Core-Calypso',
	#package : 'NewTools-Core',
	#tag : 'Calypso'
}

{ #category : 'accessing' }
StBrowserSearchPresenter class >> defaultPreferredExtent [

	^ 400@500
]

{ #category : 'examples' }
StBrowserSearchPresenter class >> exampleConfiguringPresenter [
	<example>
	
	((self newApplication: StPharoApplication current) 
		searchConfiguring: [ :presenter :dialog |
			 dialog title: 'Choose package'.
			 presenter
				 items: (self packageOrganizer packages sorted: #name ascending);
				 searchWithItem: self class package ]) 
		inspect
]

{ #category : 'examples' }
StBrowserSearchPresenter class >> exampleConfiguringPresenterForMultipleSelection [
	<example>
	
	((self newApplication: StPharoApplication current) 
		searchConfiguring: [ :presenter :dialog |
			dialog title: 'Choose package'.
		 	presenter
				 items: (self packageOrganizer packages sorted: #name ascending);
				 searchWithItem: self class package;
				 multipleSelection ]) 
			inspect
]

{ #category : 'examples' }
StBrowserSearchPresenter class >> exampleRememberingTheSearch [
	"Choose a package twice: the second dialog starts with the search accepted in the first one"

	<example>
	2 timesRepeat: [
		((self newApplication: StPharoApplication current) searchConfiguring: [ :presenter :dialog |
			 dialog title: 'Choose package'.
			 presenter
				 items: (self packageOrganizer packages sorted: #name ascending);
				 rememberSearchAs: #package ]) inspect ]
]

{ #category : 'remembered searches' }
StBrowserSearchPresenter class >> lastSearchAs: aKey [
	"The last search accepted in a dialog remembering its search as aKey (see rememberSearchAs:), or an empty string"

	^ self lastSearches at: aKey ifAbsent: [ '' ]
]

{ #category : 'remembered searches' }
StBrowserSearchPresenter class >> lastSearches [
	"The last search accepted for each key, shared by all the dialogs remembering their search"

	^ lastSearches ifNil: [ lastSearches := Dictionary new ]
]

{ #category : 'remembered searches' }
StBrowserSearchPresenter class >> lastSearches: aDictionary [

	lastSearches := aDictionary
]

{ #category : 'remembered searches' }
StBrowserSearchPresenter class >> rememberSearch: aString as: aKey [

	self lastSearches at: aKey put: aString
]

{ #category : 'instance creation' }
StBrowserSearchPresenter class >> searchConfiguring: aBlock [

  self flag: #TODO. "Remove once integrated changes in Pharo14"
	^ (self newApplication: StPharoApplication current) searchConfiguring: aBlock
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> connectPresenters [

	super connectPresenters.

	searchField whenTextChangedDo: [ self updateList ]
]

{ #category : 'layout' }
StBrowserSearchPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: itemsList;
		  add: searchField expand: false;
		  add: searchOptions expand: false;
		  yourself
]

{ #category : 'api' }
StBrowserSearchPresenter >> display: aBlock [

	itemsList display: aBlock
]

{ #category : 'api' }
StBrowserSearchPresenter >> displayOf: anItem [

	^ itemsList display value: anItem
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	super initializeDialogWindow: aDialogWindowPresenter.
	searchField whenSubmitDo: [ :protocolName | aDialogWindowPresenter triggerOkAction ]
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializePresenters [

	super initializePresenters.

	itemsList := self newList.
	searchField := self newTextInput.

	itemsList display: [ :entity | entity name ].

	self 
		initializeSearchField;
		initializeSearchOptions.
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializeSearchField [

	searchField placeholder: 'Filter...'.
	searchField eventHandler 
		whenKeyDownDo: [ :anEvent | 
			"If we press arrow up, we should get up in the list. If we press arrow down, we should get down in the list."
			
			"31 = Arrow down"
			anEvent keyValue = 31 
				ifTrue: [ itemsList selectIndex: (itemsList selection selectedIndex + 1 min: itemsList items size) scrollToSelection: true ].
			
			"30 = Arrow up"
			anEvent keyValue = 30 
				ifTrue: [ itemsList selectIndex: (itemsList selection selectedIndex - 1 max: 1) scrollToSelection: true ] ]
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializeSearchOptions [

	searchOptions := self instantiate: SpSearchInputFieldOptionsPresenter.
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter whenOpenedDo: [ searchField takeKeyboardFocus ]
]

{ #category : 'api' }
StBrowserSearchPresenter >> items: aCollection [

	items := aCollection.
	self updateList
]

{ #category : 'accessing' }
StBrowserSearchPresenter >> itemsList [
	^ itemsList
]

{ #category : 'api' }
StBrowserSearchPresenter >> multipleSelection [

	itemsList beMultipleSelection
]

{ #category : 'private' }
StBrowserSearchPresenter >> rememberSearch [

	searchKey ifNotNil: [ self class rememberSearch: self searchValue as: searchKey ]
]

{ #category : 'api' }
StBrowserSearchPresenter >> rememberSearchAs: aKey [
	"Start with the last search accepted in a dialog remembering its search as aKey (a symbol naming what is searched, such as #class), unless a search is already set, and remember the search of this one when it is accepted"

	searchKey := aKey.
	searchField text ifEmpty: [ self searchValue: (self class lastSearchAs: aKey) ]
]

{ #category : 'updating' }
StBrowserSearchPresenter >> search: text [
	"Main search callback method. Answer a <Collection> of results"

	^ OrderedCollection streamContents: [ :stream |
		  items do: [ :item | (self selectBlock value: (self displayOf: item) value: text) ifTrue: [ stream nextPut: item ] ] ]
]

{ #category : 'instance creation' }
StBrowserSearchPresenter >> searchConfiguring: aBlock [
	| dialog |
	
	dialog := self asBlockedDialogWindow.

	aBlock cull: self cull: dialog.

	self selectSearchPattern.

	dialog open.

	dialog isCancelled ifTrue: [ ^ CmCommandAborted signal ].

	self rememberSearch.

	^ self itemsList isMultipleSelection
		  ifTrue: [ self selectedItems ifEmpty: [ CmCommandAborted signal ] ]
		  ifFalse: [ self selectedItem ifNil: [ CmCommandAborted signal ] ]
]

{ #category : 'updating' }
StBrowserSearchPresenter >> searchOptions [
	"Answer the receiver's search options presenter"

	^ searchOptions
]

{ #category : 'api' }
StBrowserSearchPresenter >> searchValue [

	^ searchField text
]

{ #category : 'api' }
StBrowserSearchPresenter >> searchValue: aString [

	searchField text: aString
]

{ #category : 'api' }
StBrowserSearchPresenter >> searchWithItem: anItem [

	self searchValue: (self displayOf: anItem)
]

{ #category : 'updating' }
StBrowserSearchPresenter >> selectBlock [
	"Answer a <Closure> used to search each item in the receiver"

	^ searchOptions selectBlock
]

{ #category : 'accessing' }
StBrowserSearchPresenter >> selectSearchPattern [

	searchField selectAll
]

{ #category : 'accessing' }
StBrowserSearchPresenter >> selectedItem [

	^ itemsList selectedItem
]

{ #category : 'accessing' }
StBrowserSearchPresenter >> selectedItems [

	^ itemsList selectedItems
]

{ #category : 'updating' }
StBrowserSearchPresenter >> updateList [

	| newItems env |
	
	env := self class environment.
	newItems := searchField text
		            ifEmpty: [ items ]
		            ifNotEmpty: [ :text | self search: text ].

	itemsList items = newItems ifFalse: [
		itemsList items: newItems ].
	
	(env hasClassNamed: searchField text)
		ifTrue: [ itemsList selectItem: (env at: searchField text asSymbol) scrollToSelection: true ]
		ifFalse: [ itemsList selectFirst ]
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> windowTitle [ 

	^ 'Choose item'
]
