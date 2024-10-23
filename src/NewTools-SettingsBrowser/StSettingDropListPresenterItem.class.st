Class {
	#name : 'StSettingDropListPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingDropListPresenterItem >> initializePresenters [ 

	setterPresenter := self newDropList
		items: self model domainValues;
		display: [ : item | item asString ];
		selectIndex: self model index;
		whenSelectedItemChangedDo: [ :item | self updateSetting: item ];
		yourself.
	super initializePresenters.
]

{ #category : 'initialization' }
StSettingDropListPresenterItem >> updateSetting: aSettingDeclaration [ 
	"Private - Callback for updating aSettingDeclaration with the new receiver's selected item"

	self model targetSelector
	 ifNil: [ 
		self model target 
			perform: self model setSelector
			with: aSettingDeclaration default ] 
	ifNotNil: [
		(self model target perform: self model targetSelector) 
			perform: self model setSelector
			with: aSettingDeclaration default ]

]

{ #category : 'accessing' }
StSettingDropListPresenterItem >> value: anObject [

	setterPresenter items: anObject
]
