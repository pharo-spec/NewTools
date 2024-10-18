Class {
	#name : 'StComposedMessageElementPresenter',
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
StComposedMessageElementPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: locationLabel;
			add: packageLabel expand: false;
			yourself);
		add: selectorLabel;
		yourself
]

{ #category : 'initialization' }
StComposedMessageElementPresenter >> initializePresenters [

	locationLabel := self newLabel
		addStyle: 'dim';
		yourself.
	selectorLabel := self newLabel.
	packageLabel := self newLabel
		addStyle: 'dim';
		yourself
]

{ #category : 'accessing' }
StComposedMessageElementPresenter >> messageList: aPresenter [

	messageList := aPresenter
]

{ #category : 'initialization' }
StComposedMessageElementPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	selectorLabel label: (messageList selectorOf: self model) trimmed.
	packageLabel label: (messageList packageOf: self model) trimmed.
	locationLabel label: (messageList locationOf: self model) trimmed	
]
