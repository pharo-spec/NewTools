"
Presents a toolbar for various Settings Browser presenters.
Currently it holds widget presenters related to the search of settings.

"
Class {
	#name : 'StSettingsToolbarPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'searchInputPresenter',
		'searchButtonPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'layout' }
StSettingsToolbarPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight 
		add: searchInputPresenter;
		add: searchButtonPresenter withConstraints: [ : constraints | 
			constraints 
				expand: false;
				width: 30 ]
		yourself
]

{ #category : 'initialization' }
StSettingsToolbarPresenter >> doSettingSearch: aString [
	"Private - Callback to search aString in the receiver's descriptions and label. For performance reasons, start to search from the third character typed "

	| colOfStSettingNode mainPresenter |
	aString
		ifNotEmpty: [ searchButtonPresenter enable ]
		ifEmpty: [ searchButtonPresenter disable ].
	aString size >= 3
		ifFalse: [ ^ self ].

	colOfStSettingNode := self settingsTree processSearch: aString.
	mainPresenter := self owner.
	mainPresenter pagePresenter addSearchResultTabFrom: colOfStSettingNode.
]

{ #category : 'initialization' }
StSettingsToolbarPresenter >> initializePresenters [

	searchInputPresenter := self newSearchInput
		placeholder: 'Find in settings';
		whenTextChangedDo: [ : aString | self doSettingSearch: aString trimmed ];
		yourself.
	searchButtonPresenter := self newButton
		iconName: #smallFind;	
		disable;			
		action: [ self doSettingSearch: searchInputPresenter text trimmed ];
		yourself.
]
