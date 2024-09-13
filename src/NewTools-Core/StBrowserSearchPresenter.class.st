"
I am a presenter that gets a list of elements and that allows one to select one (or multiple if the #multipleSelection option is enabled).
"
Class {
	#name : 'StBrowserSearchPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'items',
		'itemsList',
		'searchField'
	],
	#category : 'NewTools-Core-Calypso',
	#package : 'NewTools-Core',
	#tag : 'Calypso'
}

{ #category : 'examples' }
StBrowserSearchPresenter class >> exampleConfiguringPresenter [

	<example>
	(self searchConfiguring: [ :presenter :dialog |
		 dialog title: 'Choose package'.
		 presenter
			 items: (self packageOrganizer packages sorted: #name ascending);
			 searchWithItem: self class package ]) inspect
]

{ #category : 'examples' }
StBrowserSearchPresenter class >> exampleConfiguringPresenterForMultipleSelection [

	<example>
	(self searchConfiguring: [ :presenter :dialog |
		 dialog title: 'Choose package'.
		 presenter
			 items: (self packageOrganizer packages sorted: #name ascending);
			 searchWithItem: self class package;
			 multipleSelection ]) inspect
]

{ #category : 'instance creation' }
StBrowserSearchPresenter class >> open [

	<script>
	self new open
]

{ #category : 'instance creation' }
StBrowserSearchPresenter class >> searchConfiguring: aBlock [

	<script>
	| presenter dialog |
	dialog := (presenter := self new) asBlockedDialogWindow.

	aBlock cull: presenter cull: dialog.

	presenter selectSearchPattern.

	dialog open.

	dialog cancelled ifTrue: [ ^ CmCommandAborted signal ].

	^ presenter itemsList isMultipleSelection
		  ifTrue: [ presenter selectedItems ifEmpty: [ CmCommandAborted signal ] ]
		  ifFalse: [ presenter selectedItem ifNil: [ CmCommandAborted signal ] ]
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
		  yourself
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

	searchField placeholder: 'Filter...'.
	searchField eventHandler whenKeyDownDo: [ :anEvent | "If we press arrow up, we should get up in the list. If we press arrow down, we should get down in the list.""31 = Arrow down"
		anEvent keyValue = 31 ifTrue: [ itemsList selectIndex: (itemsList selection selectedIndex + 1 min: itemsList items size) scrollToSelection: true ].
		"30 = Arrow up"
		anEvent keyValue = 30 ifTrue: [ itemsList selectIndex: (itemsList selection selectedIndex - 1 max: 1) scrollToSelection: true ] ]
]

{ #category : 'initialization' }
StBrowserSearchPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Choose item'.

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

{ #category : 'api' }
StBrowserSearchPresenter >> searchValue: aString [

	searchField text: aString
]

{ #category : 'api' }
StBrowserSearchPresenter >> searchWithItem: anItem [

	self searchValue: (itemsList display value: anItem)
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

	| newItems |
	newItems := searchField text ifEmpty: [ items ] ifNotEmpty: [ :text |
		            | regex |
		            regex := text asRegexIgnoringCase.
		            items select: [ :item | regex search: (itemsList display value: item) ] ].

	itemsList items = newItems ifFalse: [
		itemsList
			items: newItems;
			selectFirst ]
]
