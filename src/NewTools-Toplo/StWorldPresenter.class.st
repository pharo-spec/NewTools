Class {
	#name : 'StWorldPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'menu'
	],
	#category : 'NewTools-Toplo',
	#package : 'NewTools-Toplo'
}

{ #category : 'initialization' }
StWorldPresenter >> initializePresenters [

	super initializePresenters.

	layout := SpBoxLayout newVertical.
	menu := StWorldMenuBuilder new buildMenuBarPresenterFor: self
]

{ #category : 'initialization' }
StWorldPresenter >> initializeWindow: aSpWindow [

	super initializeWindow: aSpWindow.
	aSpWindow extent: 800@800.
	aSpWindow menu: menu
]

{ #category : 'as yet unclassified' }
StWorldPresenter >> openAsWorld [
	
	^ application openAsWorld: self 
]

{ #category : 'as yet unclassified' }
StWorldPresenter >> wrapMenuAction: aBlockClosure [ 
	
	aBlockClosure ifNil: [ ^ nil ].
	
	^ [ self application useDuring: aBlockClosure ]
]
