Class {
	#name : 'StMethodHistoryToolbarPresenter',
	#superclass : 'SpMethodToolbarPresenter',
	#instVars : [
		'revertAction'
	],
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'actions' }
StMethodHistoryToolbarPresenter >> doRevert [

	revertAction ifNil: [ ^ self ].
	revertAction value
]

{ #category : 'initialization' }
StMethodHistoryToolbarPresenter >> initializePresenters [

	super initializePresenters.
	Smalltalk ui icons.
	versionButton 
		label: 'Revert';
		icon: (self iconNamed: #smallUndo);
		help: 'Revert method to selected version.';
		action: [ self doRevert ]
]

{ #category : 'events' }
StMethodHistoryToolbarPresenter >> whenRevertDo: aBlock [

	revertAction := aBlock
]
