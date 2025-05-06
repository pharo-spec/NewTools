Class {
	#name : 'StPulseRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'contextPresenter'
	],
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'layout' }
StPulseRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		spacing: 5;
		borderWidth: 2;
		add: namePresenter;
		add: contextPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
StPulseRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockSpotterRow'.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel.
	contextPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
	
]

{ #category : 'initialization' }
StPulseRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	
	iconPresenter image: (self model iconOn: self application).
	namePresenter label: self model label.
	contextPresenter label: self model categoryLabel
]
