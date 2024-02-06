"
Wrapper for presenting a setting containing a `String` or `Text`.
"
Class {
	#name : 'StSettingTextPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingTextPresenterItem >> initializePresenters [ 

	super initializePresenters.
	setterPresenter := self newTextInput
		beEditable;
		placeholder: self model label;		
		yourself 
]

{ #category : 'accessing' }
StSettingTextPresenterItem >> value: aString [ 
	"Set the receiver's value to aString"

	self setterPresenter text: aString.
]
