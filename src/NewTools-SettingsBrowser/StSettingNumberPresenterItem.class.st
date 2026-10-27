"
Wrapper for settings containing a `Number` type. Users send `#beFloat` or `#beInteger` to configure the wrapper.
"
Class {
	#name : 'StSettingNumberPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingNumberPresenterItem >> beFloat [

	self setterPresenter beFloat
]

{ #category : 'initialization' }
StSettingNumberPresenterItem >> beInteger [

	self setterPresenter beInteger
]

{ #category : 'initialization' }
StSettingNumberPresenterItem >> initializePresenters [ 

	setterPresenter := self newNumberInput.
	super initializePresenters.
	setterPresenter whenNumberChangedDo: [ :value | self updateSetting: value ] 
]

{ #category : 'accessing' }
StSettingNumberPresenterItem >> settingStyle [

	^ 'itemNumber'
]

{ #category : 'accessing' }
StSettingNumberPresenterItem >> value: aNumber [ 
	"Set the receiver's value to aNumber"

	self setterPresenter number: aNumber
]
