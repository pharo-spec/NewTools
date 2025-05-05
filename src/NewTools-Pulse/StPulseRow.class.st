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
	
	
	iconPresenter image: (self iconNamed: (self model iconName ifNil: [ #blank ])).
	namePresenter label: self model label.
	contextPresenter label: self model categoryLabel
]
