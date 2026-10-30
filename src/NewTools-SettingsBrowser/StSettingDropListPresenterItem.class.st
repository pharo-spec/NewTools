Class {
	#name : 'StSettingDropListPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingDropListPresenterItem >> initializePresenters [ 

	| indexOfCurrentValue |
	setterPresenter := self newDropList
		items: self model domainValues;
		display: [ :item | item name asString ];
		whenSelectedItemChangedDo: [ :item | self shouldUpdateSetting ifTrue: [ self updateSetting: item ] ];
		yourself.	
	indexOfCurrentValue := self model domainValues detectIndex: [ :each | each value = self model realValue ].
	self withoutUpdatingSettingDo: [ setterPresenter selectIndex: indexOfCurrentValue ].
	super initializePresenters
]

{ #category : 'accessing' }
StSettingDropListPresenterItem >> settingStyle [

	^ 'itemDropList'
]

{ #category : 'initialization' }
StSettingDropListPresenterItem >> updateSetting: aSettingItem [
	"Private - Callback for updating aSettingDeclaration with the new receiver's selected item"

	aSettingItem beCurrentValue
]

{ #category : 'accessing' }
StSettingDropListPresenterItem >> value: anObject [

	setterPresenter items: anObject
]
