"
I am a presenter to show a summary of a page.
It will include the first line of the page and the creation date.
I am meant to be used in StPlaygroundPagesPresenter, as element of a list.
"
Class {
	#name : 'StPlaygroundPageSummaryPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'firstLineLabel',
		'timeLabel'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'accessing' }
StPlaygroundPageSummaryPresenter >> contents [

	^ self model contents
]

{ #category : 'initialization' }
StPlaygroundPageSummaryPresenter >> initializePresenters [

	layout := SpBoxLayout newTopToBottom
		borderWidth: 1;
		spacing: 2;
		add: (firstLineLabel := self newLabel) expand: false;
		add: (timeLabel := self newLabel) expand: false;
		yourself.

	timeLabel addStyle: 'dim'
]

{ #category : 'accessing' }
StPlaygroundPageSummaryPresenter >> page [

	^ self model
]

{ #category : 'initialization' }
StPlaygroundPageSummaryPresenter >> pageTitle [

	^ self model title
]

{ #category : 'initialization' }
StPlaygroundPageSummaryPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	firstLineLabel label: self pageTitle.
	timeLabel label: self model modificationTime epiceaBrowsersAsString
]
