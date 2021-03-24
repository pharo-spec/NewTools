"
A presenter to display a group of results.
Each processor define a group. 
Each group has a list of children (instances of *StSpotterCandidateListPresenter). 

"
Class {
	#name : #StSpotterHeaderPresenter,
	#superclass : #StSpotterBasePresenter,
	#instVars : [
		'model',
		'candidatePresentersList',
		'labelPresenter',
		'diveButtonPresenter',
		'diveInAction',
		'finalAmount',
		'amountLabelPresenter',
		'entryClass',
		'helpLabelPresenter',
		'order'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #accessing }
StSpotterHeaderPresenter >> addCandidate: aCandidateLink inSpotter: spotterPresenter [

	candidatePresentersList add: (spotterPresenter newSpotterCandidateLinkPresenter: aCandidateLink).
	self updateAmount
]

{ #category : #'private actions' }
StSpotterHeaderPresenter >> diveIn [

	diveInAction ifNil: [ ^ self ].
	diveInAction cull: self model
]

{ #category : #accessing }
StSpotterHeaderPresenter >> finalAmount [

	^ finalAmount
]

{ #category : #accessing }
StSpotterHeaderPresenter >> finalAmount: aNumber [

	finalAmount := aNumber
]

{ #category : #testing }
StSpotterHeaderPresenter >> includesLink: aLink [

	^ candidatePresentersList anySatisfy: [ :each | each entry = aLink value ]
]

{ #category : #initialization }
StSpotterHeaderPresenter >> initialize [

	candidatePresentersList := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
StSpotterHeaderPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 5;
		spacing: 5;
		vAlignCenter;
		add: (labelPresenter := self newLabel) expand: false;
		add: (amountLabelPresenter := self newLabel) expand: false;
		add: (helpLabelPresenter := self newLabel) expand: false;
		addLast: (diveButtonPresenter := self newImage) expand: false; 
		yourself).

	self addStyle: 'stSpotterHeader'.
	amountLabelPresenter addStyle: 'dim'.
	helpLabelPresenter addStyle: 'dim'.
	diveButtonPresenter image: (self application iconNamed: #smallForward).
	diveButtonPresenter eventHandler
		whenMouseDownDo: [ :event | 
			event isPrimaryButton ifTrue: [ self diveIn ] ].
]

{ #category : #testing }
StSpotterHeaderPresenter >> isHeader [

	^ true
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> model [

	^ model
]

{ #category : #accessing }
StSpotterHeaderPresenter >> order [

	^ order ifNil: [ self model order ]
]

{ #category : #accessing }
StSpotterHeaderPresenter >> prepareAsClasses [

	labelPresenter label: '#Classes'.
	helpLabelPresenter label: (KMShortcutPrinter toString: self model keyBindingForClasses).
]

{ #category : #accessing }
StSpotterHeaderPresenter >> prepareAsImplementors [

	order := self model order + 1.
	labelPresenter label: '#Implementors'.
	helpLabelPresenter label: (KMShortcutPrinter toString: self model keyBindingForImplementors).
]

{ #category : #accessing }
StSpotterHeaderPresenter >> prepareAsPackages [

	order := self model order - 1.
	labelPresenter label: '#Packages'
]

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> setModelBeforeInitialization: aProcessor [

	model := aProcessor
]

{ #category : #accessing }
StSpotterHeaderPresenter >> type: aClass [

	 aClass prepareUnifiedHeaderDescriptionFor: self
]

{ #category : #'private updating' }
StSpotterHeaderPresenter >> updateAmount [

	amountLabelPresenter label: ('{1}/{2}' format: { 
		candidatePresentersList size. 
		self finalAmount ifNil: [ '...' ] })
]

{ #category : #initialization }
StSpotterHeaderPresenter >> updatePresenter [

	labelPresenter label: '#', self model title.
	helpLabelPresenter label: (self model keyBinding 
		ifNotNil: [ :binding | binding asString ]
		ifNil: [ '' ])
]

{ #category : #enumerating }
StSpotterHeaderPresenter >> whenDiveInDo: aBlock [

	diveInAction := aBlock
]

{ #category : #accessing }
StSpotterHeaderPresenter >> withCandidates [

	^ { self }, candidatePresentersList
]
