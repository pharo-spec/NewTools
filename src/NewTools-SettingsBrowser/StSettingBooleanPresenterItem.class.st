"
Wrapper for settings containing a `Booleam` type.
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

	super initializePresenters.
	setterPresenter := self newCheckBox.
]

{ #category : 'accessing' }
StSettingBooleanPresenterItem >> value: aBoolean [

	self setterPresenter state: aBoolean
]
