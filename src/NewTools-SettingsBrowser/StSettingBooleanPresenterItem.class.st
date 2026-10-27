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

	setterPresenter := self newCheckBox
		whenActivatedDo: [ self updateSetting: self model value: true ];
		whenDeactivatedDo: [ self updateSetting: self model value: false ].
	super initializePresenters

]

{ #category : 'accessing' }
StSettingBooleanPresenterItem >> settingStyle [

	^ 'itemBoolean'
]

{ #category : 'initialization' }
StSettingBooleanPresenterItem >> updateSetting: aSettingDeclaration value: aBoolean [
	"Private - Callback for updating aSettingDeclaration with the new receiver's selected item"

	aSettingDeclaration realValue: aBoolean
]

{ #category : 'accessing' }
StSettingBooleanPresenterItem >> value: aBoolean [

	self setterPresenter state: aBoolean
]
