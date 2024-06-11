"
Wrapper for settings containing a `Boolean` type.
"
Class {
	#name : 'StSettingBooleanPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingBooleanPresenterItem >> initializePresenters [ 

	setterPresenter := self newCheckBox.
	super initializePresenters.

]

{ #category : 'accessing' }
StSettingBooleanPresenterItem >> value: aBoolean [

	self setterPresenter state: aBoolean
]
