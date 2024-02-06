Class {
	#name : 'StSettingSHStyleButtonPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'accessing' }
StSettingSHStyleButtonPresenterItem >> buttonAction: aFullBlockClosure [ 

	self setterPresenter action: aFullBlockClosure
]

{ #category : 'font accessing' }
StSettingSHStyleButtonPresenterItem >> buttonFont: aLogicalFont [ 

	self setterPresenter font: aLogicalFont
]

{ #category : 'initialization' }
StSettingSHStyleButtonPresenterItem >> buttonLabel: aString [

	self setterPresenter label: aString.
]

{ #category : 'initialization' }
StSettingSHStyleButtonPresenterItem >> initializePresenters [ 

	super initializePresenters.
	setterPresenter := self newButton
]
