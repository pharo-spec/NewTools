"
I am a presenter to show a summary of a page.
It will include the first line of the page and the creation date.
I am meant to be used in StPlaygroundPagesPresenter, as element of a list.
"
Class {
	#name : #SpPlaygroundPageSummaryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'page',
		'firstLineLabel',
		'timeLabel'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
SpPlaygroundPageSummaryPresenter >> contents [

	^ page contents
]

{ #category : #initialization }
SpPlaygroundPageSummaryPresenter >> initializePresenters [

	layout := SpBoxLayout newVertical
		borderWidth: 1;
		spacing: 2;
		add: (firstLineLabel := self newLabel) expand: false;
		add: (timeLabel := self newLabel) expand: false;
		yourself.

	firstLineLabel label: self pageFirstLine.
	timeLabel 
		addStyle: 'dim';
		label: page creationTime epiceaBrowsersAsString
]

{ #category : #accessing }
SpPlaygroundPageSummaryPresenter >> page [

	^ page
]

{ #category : #initialization }
SpPlaygroundPageSummaryPresenter >> pageFirstLine [
		
	page readStreamDo: [ :stream | | line |
		[ stream atEnd not and: [ (line := stream nextLine trimmed) isEmpty ] ] whileTrue.
		line ifNotEmpty: [ ^ line ] ].

	^ 'Empty'
]

{ #category : #'accessing model' }
SpPlaygroundPageSummaryPresenter >> setModelBeforeInitialization: aPage [

	page := aPage
]
