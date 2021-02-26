Class {
	#name : #StSpotterHeaderPresenter,
	#superclass : #StSpotterPresenter,
	#instVars : [
		'labelPresenter',
		'model',
		'shortcutLabelPresenter',
		'diveButtonPresenter',
		'diveInAction'
	],
	#category : #'NewTools-Spotter-View'
}

{ #category : #'private actions' }
StSpotterHeaderPresenter >> diveIn [

	diveInAction ifNil: [ ^ self ].
	diveInAction cull: self model
]

{ #category : #initialization }
StSpotterHeaderPresenter >> initializePresenters [

	self layout: (SpBoxLayout newHorizontal
		borderWidth: 5;
		spacing: 5;
		add: (labelPresenter := self newLabel) expand: false;
		add: (shortcutLabelPresenter := self newLabel) expand: false;
		addLast: (diveButtonPresenter := self newImage) expand: false; 
		yourself).

	self addStyle: 'stSpotterHeader'.
	shortcutLabelPresenter addStyle: 'dim'.
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

{ #category : #initialization }
StSpotterHeaderPresenter >> updatePresenter [

	labelPresenter label: '#', self model title
]

{ #category : #enumerating }
StSpotterHeaderPresenter >> whenDiveInDo: aBlock [

	diveInAction := aBlock
]
