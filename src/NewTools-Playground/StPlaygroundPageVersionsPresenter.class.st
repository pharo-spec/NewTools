"
A presenter to show all stored versions of a page. 
A version is taken each time we will flush a new version of the page to the disk, making changes in the playground recoverable..
"
Class {
	#name : 'StPlaygroundPageVersionsPresenter',
	#superclass : 'StPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'versionList',
		'sourceCode'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'accessing' }
StPlaygroundPageVersionsPresenter class >> preferredExtent [

	^ (700@400)
]

{ #category : 'actions' }
StPlaygroundPageVersionsPresenter >> adoptSelectedVersion [

	self adoptVersion: versionList selectedItem
]

{ #category : 'actions' }
StPlaygroundPageVersionsPresenter >> adoptVersion: anEntry [

	self parent contents: anEntry content.
	self window close.
	self parent takeKeyboardFocus
]

{ #category : 'private' }
StPlaygroundPageVersionsPresenter >> displayValueFor: aDateAndTime [

	"^ ((DateAndTime now - aDateAndTime) truncateTo: 2 minutes) humanReadablePrintString"
	^ aDateAndTime epiceaBrowsersAsString
]

{ #category : 'actions' }
StPlaygroundPageVersionsPresenter >> doAdoptVersion [

	self adoptSelectedVersion
]

{ #category : 'actions' }
StPlaygroundPageVersionsPresenter >> doAdoptVersionOnNewPlayground [
	| playground |
	
	(playground := StPlaygroundPresenter new) 
		contents: versionList selectedItem content;
		open.
	self window close.
	playground takeKeyboardFocus
]

{ #category : 'initialization' }
StPlaygroundPageVersionsPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Close' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Adopt' do: [ :presenter | 
			presenter triggerOkAction.
			self adoptSelectedVersion ]
]

{ #category : 'initialization' }
StPlaygroundPageVersionsPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		positionOfSlider: 40 percent;
		add: (versionList := self newList);
		add: (sourceCode := self newCode);
		yourself).
		
	versionList
		 display: [ :anEntry | self displayValueFor: (anEntry tagAt: #timestamp) ];
		 actions: self versionsActions.

	sourceCode 
		beForScripting;
		beNotEditable.
	
	versionList 
		transmitTo: sourceCode 
		transform: [ :anEntry | 
			anEntry 
				ifNotNil: [ anEntry content ]
				ifNil: [ 'no source' ] ]
]

{ #category : 'initialization' }
StPlaygroundPageVersionsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Versions';
		initialExtent: self class preferredExtent
]

{ #category : 'private' }
StPlaygroundPageVersionsPresenter >> parent [
	"a synonym to be clearer"

	^ self model
]

{ #category : 'initialization' }
StPlaygroundPageVersionsPresenter >> updatePresenter [

	versionList items: self model page versions reversed
]

{ #category : 'initialization' }
StPlaygroundPageVersionsPresenter >> versionsActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (StPlaygroundAdoptVersionCommand forSpecContext: self);
		register: (StPlaygroundAdoptVersionOnNewPlaygroundCommand forSpecContext: self);
		yourself
]
