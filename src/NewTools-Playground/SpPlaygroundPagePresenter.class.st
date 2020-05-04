Class {
	#name : #SpPlaygroundPagePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'page',
		'firstLineLabel',
		'timeLabel'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #'as yet unclassified' }
SpPlaygroundPagePresenter >> contents [

	^ page contents
]

{ #category : #initialization }
SpPlaygroundPagePresenter >> initializePresenters [

	layout := SpBoxLayout newVertical
		borderWidth: 1;
		add: (firstLineLabel := self newLabel) expand: false;
		add: (timeLabel := self newLabel) expand: false;
		yourself.

	firstLineLabel label: self pageFirstLine.
	timeLabel 
		addStyle: 'dim';
		label: page creationTime asString
]

{ #category : #initialization }
SpPlaygroundPagePresenter >> pageFirstLine [
		
	page readStreamDo: [ :stream | | lineReader |
		lineReader := ZnLineReader on: stream.
		^ (lineReader nextLine) trimmed ].
	
	^ 'Empty'
]

{ #category : #'accessing model' }
SpPlaygroundPagePresenter >> setModelBeforeInitialization: aPage [

	page := aPage
]
