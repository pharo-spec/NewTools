Class {
	#name : #StSpotterHeaderPresenter,
	#superclass : #StSpotterPresenter,
	#instVars : [
		'model',
		'candidatePresentersList',
		'labelPresenter',
		'diveButtonPresenter',
		'diveInAction',
		'finalAmount',
		'amountLabelPresenter'
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

{ #category : #initialization }
StSpotterHeaderPresenter >> initialize [

	candidatePresentersList := OrderedCollection new.
	super initialize.
]

{ #category : #initialization }
StSpotterHeaderPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 5;
		spacing: 5;
		add: (labelPresenter := self newLabel) expand: false;
		add: (amountLabelPresenter := self newLabel) expand: false;
		addLast: (diveButtonPresenter := self newImage) expand: false; 
		yourself).

	self addStyle: 'stSpotterHeader'.
	amountLabelPresenter addStyle: 'dim'.
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

{ #category : #'accessing model' }
StSpotterHeaderPresenter >> setModelBeforeInitialization: aProcessor [

	model := aProcessor
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
	amountLabelPresenter label: (self model keyBinding 
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
