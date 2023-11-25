Class {
	#name : 'SpMessageToolbarPresenter',
	#superclass : 'SpMethodToolbarPresenter',
	#instVars : [
		'flipAction'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'actions' }
SpMessageToolbarPresenter >> doFlipLayout [

	flipAction ifNil: [ ^ self ].
	flipAction value
]

{ #category : 'initialization' }
SpMessageToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	toolbarPresenter add: (self newToolbarButton
		label: 'Flip';
		action: [ self doFlipLayout ])
]

{ #category : 'events' }
SpMessageToolbarPresenter >> whenFlipLayoutDo: aBlock [

	flipAction := aBlock
]
