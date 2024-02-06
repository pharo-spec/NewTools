"
The Settings Browser it is organized in three main Spec presenters:

- A toolbar which holds operations to be performed (mainly searching), presented by `StSettingsToolbarPresenter`.
- A presenter for ""main categories"", presented by `StSettingsCategoriesPresenter`.
- And a ""details presenter"", presented by `StSettingsPagePresenter`, instantiated when the users selects a main category.
"
Class {
	#name : 'StSettingsMainPresenter',
	#superclass : 'StSettingsAbstracPresenter',
	#instVars : [
		'toolbarPresenter',
		'detailsPresenter',
		'mainCategoriesPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'initialization' }
StSettingsMainPresenter >> browserTitle [ 

	^ 'Settings Browser'
]

{ #category : 'initialization' }
StSettingsMainPresenter >> connectPresenters [ 

	mainCategoriesPresenter 
		transmitTo: detailsPresenter
		transform: [ : aCategoryItemPresenter | aCategoryItemPresenter node ]
]

{ #category : 'layout' }
StSettingsMainPresenter >> defaultInputPort [ 

	^ SpListItemsPort newPresenter: detailsPresenter

]

{ #category : 'layout' }
StSettingsMainPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal 
		positionOfSlider: 0.2;		
		add: (SpBoxLayout newTopToBottom
				add: toolbarPresenter withConstraints: [ : constraints |
					constraints 
						height: self class toolbarHeight + 10;
						padding: 5 ];
			add:  mainCategoriesPresenter;
			yourself);
		add: detailsPresenter;
		yourself
]

{ #category : 'ports' }
StSettingsMainPresenter >> defaultOutputPort [ 

	^ mainCategoriesPresenter
]

{ #category : 'initialization' }
StSettingsMainPresenter >> initializeFocus [

	self focusOrder 
		add: toolbarPresenter;
		add: mainCategoriesPresenter;
		add: detailsPresenter
]

{ #category : 'initialization' }
StSettingsMainPresenter >> initializePresenters [

	toolbarPresenter := self instantiate: StSettingsToolbarPresenter on: self.
	mainCategoriesPresenter := self instantiate: StSettingsCategoriesPresenter on: self.
	detailsPresenter := self instantiate: StSettingsPagePresenter on: self.
	
	self initializeFocus.
]

{ #category : 'initialization' }
StSettingsMainPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self browserTitle;
		initialExtent: 1000 @ 700;
		centered
]
