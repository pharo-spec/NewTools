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

	setterPresenter := self newTextInput
		beEditable;
		placeholder: self model label;
		yourself.
	super initializePresenters.
	setterPresenter whenTextChangedDo: [ :text | self shouldUpdateSetting ifTrue: [ self updateSetting: text ] ].
]

{ #category : 'accessing' }
StSettingTextPresenterItem >> settingStyle [

	^ 'itemText'
]

{ #category : 'accessing' }
StSettingTextPresenterItem >> value: aString [ 
	"Set the receiver's value to aString"

	self withoutUpdatingSettingDo: [ self setterPresenter text: aString ]
]
