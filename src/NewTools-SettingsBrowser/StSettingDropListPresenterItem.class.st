Class {
	#name : 'StSettingDropListPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingDropListPresenterItem >> initializePresenters [ 

	super initializePresenters.
	setterPresenter := self newDropList
		items: self model domainValues;
		display: [ : item | item asString ];
		selectIndex: self model index;
		yourself
]

{ #category : 'accessing' }
StSettingDropListPresenterItem >> value: anObject [

	setterPresenter items: anObject
]
