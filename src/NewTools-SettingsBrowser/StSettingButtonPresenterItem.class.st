"
Wrapper for settings which present a button to apply a setting or open another presenter. This replaces the `dialog:` mechanism in the Morphic based Settings Browser.
"
Class {
	#name : 'StSettingButtonPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingButtonPresenterItem >> initializePresenters [ 

	setterPresenter := self newButton 
		label: self model actionLabel; 
		action: self model dialog;
		yourself.
	super initializePresenters.

]
