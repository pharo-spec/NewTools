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

	(setterPresenter := self newButton) 
		label: self model buttonLabel; 
		action: [
			self target perform: self model name.
			self refreshSettingsPage ];
		yourself.
	super initializePresenters
]

{ #category : 'updating' }
StSettingButtonPresenterItem >> refreshSettingsPage [
	"The action may have changed other settings: let the page showing the receiver display their new values"

	self pagePresenter ifNotNil: [ :page | page announcer announce: StSettingModelChanged ]
]

{ #category : 'accessing' }
StSettingButtonPresenterItem >> settingStyle [

	^ 'itemButton'
]

{ #category : 'accessing' }
StSettingButtonPresenterItem >> target [
	"Answer an <Object> that is the receiver of the action"

	^ self model target
]
