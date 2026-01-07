Class {
	#name : 'StComposedMethodElementPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'locationLabel',
		'selectorLabel',
		'packageLabel',
		'messageList'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'nil' }
StComposedMethodElementPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: locationLabel;
			add: packageLabel expand: false;
			yourself);
		add: selectorLabel;
		yourself
]

{ #category : 'initialization' }
StComposedMethodElementPresenter >> initializePresenters [

	locationLabel := self newLabel
		addStyle: 'dim';
		yourself.
	selectorLabel := self newLabel.
	packageLabel := self newLabel
		addStyle: 'dim';
		yourself
]

{ #category : 'accessing' }
StComposedMethodElementPresenter >> messageList: aPresenter [

	messageList := aPresenter
]

{ #category : 'initialization' }
StComposedMethodElementPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	selectorLabel label: (messageList selectorOf: self model) trimmed.
	packageLabel label: (messageList packageOf: self model) trimmed.
	locationLabel label: (messageList locationOf: self model) trimmed	
]
