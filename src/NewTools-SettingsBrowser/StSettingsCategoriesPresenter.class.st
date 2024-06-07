"
Presents a list with the main categories of settings.
Events triggered by clicking a category are defined in my owner through the transmission protocol, i.e. `StSettingsPanesPresenter >> #connectPresenters`
"
Class {
	#name : 'StSettingsCategoriesPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'categoryListPresenter',
		'settingsCategories'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'initialization' }
StSettingsCategoriesPresenter >> categoriesAsPresenters [

	^ self settingsCategories collect: [ : node | 
		(self 
			instantiate: StSettingsCategoryItemPresenter
			on: node) 
				addStyle: 'superCategoryList'  ]
]

{ #category : 'accessing' }
StSettingsCategoriesPresenter >> categoryListPresenter [

	^ categoryListPresenter
]

{ #category : 'accessing' }
StSettingsCategoriesPresenter >> categoryListPresenter: anObject [

	categoryListPresenter := anObject
]

{ #category : 'layout' }
StSettingsCategoriesPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom 
		add: categoryListPresenter;
		yourself.
]

{ #category : 'ports' }
StSettingsCategoriesPresenter >> defaultOutputPort [ 

	^ self categoryListPresenter defaultOutputPort
]

{ #category : 'initialization' }
StSettingsCategoriesPresenter >> defaultSettingsCategories [
	"Answer a <Collection> of <StSettingNodePresenter> categories to be presented by default in the receiver"
	
	^ self settingsTree defaultCategories
	
]

{ #category : 'initialization' }
StSettingsCategoriesPresenter >> initializePresenters [

	categoryListPresenter := self newComponentList
		items: self categoriesAsPresenters;
		yourself.
]

{ #category : 'initialization' }
StSettingsCategoriesPresenter >> settingsCategories [

	^ settingsCategories
		ifNil: [ settingsCategories := self defaultSettingsCategories ]
]
