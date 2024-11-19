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

	setterPresenter := self newNumberInput
			whenNumberChangedDo: self updateSettingBlock.
	super initializePresenters.
]

{ #category : 'initialization' }
StSettingNumberPresenterItem >> updateSettingBlock [
	"Answer a <BlockClosure> responsible to announce that a setting has been updated.
	Here we have a specialized version because the number presenter converts its received number as String,
	hence when a newValue is passed as a Number, we would compare Number versus String, which is always <false>"

	^ [ : newValue : oldValue | 
			newValue asString = oldValue asString ifFalse: [ 
				self codeSupportAnnouncer announce: (SettingUpdated 
					declaration: self model 
					oldValue: oldValue
					newValue: newValue) ]	 ].
]

{ #category : 'accessing' }
StSettingNumberPresenterItem >> value: aNumber [ 
	"Set the receiver's value to aNumber"

	self setterPresenter number: aNumber
]
