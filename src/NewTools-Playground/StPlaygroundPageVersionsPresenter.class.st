Class {
	#name : #StPlaygroundPageVersionsPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'versionList',
		'sourceCode'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlaygroundPageVersionsPresenter class >> preferredExtent [

	^ 700@400
]

{ #category : #private }
StPlaygroundPageVersionsPresenter >> displayValueFor: aDateAndTime [

	"^ ((DateAndTime now - aDateAndTime) truncateTo: 2 minutes) humanReadablePrintString"
	^ aDateAndTime epiceaBrowsersAsString
]

{ #category : #initialization }
StPlaygroundPageVersionsPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Adopt' do: [ :presenter | 
			presenter triggerOkAction.
			presenter close ];
		addButton: 'Close' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ]	
]

{ #category : #initialization }
StPlaygroundPageVersionsPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		positionOfSlider: 40 percent;
		add: (versionList := self newList);
		add: (sourceCode := self newCode);
		yourself).
		
	versionList display: [ :anEntry | 
		self displayValueFor: (anEntry tagAt: #timestamp) ].
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

{ #category : #initialization }
StPlaygroundPageVersionsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Versions';
		initialExtent: self class preferredExtent
]

{ #category : #initialization }
StPlaygroundPageVersionsPresenter >> updatePresenter [

	versionList items: self model page versions reversed
]
