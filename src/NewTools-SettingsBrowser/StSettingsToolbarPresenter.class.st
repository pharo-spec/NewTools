"
Presents a toolbar for various Settings Browser presenters.
Currently it holds widget presenters related to the search of settings.

"
Class {
	#name : 'StSettingsToolbarPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'searchInputPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'layout' }
StSettingsToolbarPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight 
		add: searchInputPresenter;
		yourself
]

{ #category : 'initialization' }
StSettingsToolbarPresenter >> doSettingSearch: aString [
	"Callback to search aString in the receiver's descriptions and label. 
	 For performance reasons, start to search from the third character typed."
	| colOfStSettingNode mainPresenter |
	
	mainPresenter := self owner.
	
	aString size >= 3 ifFalse: [ 
		mainPresenter ifNotNil: [
			mainPresenter resetSearchResult ].
		^ self ].

	colOfStSettingNode := self settingsTree processSearch: aString.
	mainPresenter addSearchResultFrom: colOfStSettingNode
]

{ #category : 'initialization' }
StSettingsToolbarPresenter >> initializePresenters [

	searchInputPresenter := self newSearchInput
        placeholder: 'Find in settings';
        whenTextChangedDo: [ :aString | self doSettingSearch: aString trimBoth ];
        yourself
]
