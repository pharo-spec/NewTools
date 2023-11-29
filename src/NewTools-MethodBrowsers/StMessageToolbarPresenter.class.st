Class {
	#name : 'StMessageToolbarPresenter',
	#superclass : 'StMethodToolbarPresenter',
	#instVars : [
		'flipAction'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'actions' }
StMessageToolbarPresenter >> doFlipLayout [

	flipAction ifNil: [ ^ self ].
	flipAction value
]

{ #category : 'initialization' }
StMessageToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	toolbarPresenter add: (self newToolbarButton
		label: 'Flip';
		action: [ self doFlipLayout ])
]

{ #category : 'events' }
StMessageToolbarPresenter >> whenFlipLayoutDo: aBlock [

	flipAction := aBlock
]
