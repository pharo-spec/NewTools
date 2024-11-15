"
The Settings Browser it is organized in three main Spec presenters:

- A toolbar which holds operations to be performed (mainly searching), presented by `StSettingsToolbarPresenter`.
- A presenter for ""main categories"", presented by `StSettingsCategoriesPresenter`.
- And a ""details presenter"", presented by `StSettingsPagePresenter`, instantiated when the users selects a main category.

The class side holds application assets (icons and styles) and initializers for the Settings Browser.

"
Class {
	#name : 'StSettingsMainPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'toolbarPresenter',
		'detailsPresenter',
		'mainCategoriesPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'adding' }
StSettingsMainPresenter class >> descriptionBackgroundColor [

	^ Smalltalk ui theme lightBackgroundColor asHexString
]

{ #category : 'world menu' }
StSettingsMainPresenter class >> menuSettingsBrowserCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'New Settings Browser')
		parent: #NewToolsMenu;
		label: 'New Settings Browser';
		action: [ (self newApplication: self currentApplication) open ];
		iconName: self taskbarIconName;
		help: 'New Settings Browser';
		order: 3
]

{ #category : 'accessing - styles' }
StSettingsMainPresenter class >> styleSheet [

	^ SpStyle defaultStyleSheet , 
	    (SpStyleVariableSTONReader fromString: self styleSheetString)

]

{ #category : 'accessing - styles' }
StSettingsMainPresenter class >> styleSheetString [

	^ '.application [
    .superCategoryList [ Geometry { #height: 70 } ],
	.pageTitle [ 
		Font { #name : EnvironmentFont(#default), #size : 20 },
		Geometry { #height: 15 } ],
	.pageStyle [ 
		Draw { #backgroundColor: #transparent },
		Container { #padding: 2 } ],
	.sectionTitleL1 [ 
		Draw { #backgroundColor: #gray },
		Font { #size: 16 } ],
	.sectionTitleL2 [ 
		Draw { #backgroundColor: #lightGray },
		Font { #size: 14 } ],
	.sectionTitleL3 [ 
		Draw { #backgroundColor: #veryLightGray },
		Font { #size: 12 } ],
	.sectionTitleL4 [ 
		Draw { #backgroundColor: #veryVeryLightGray },
		Font { #size: 10 } ],
	.sectionStyle [ 
		Draw { #backgroundColor: #transparent }
	 ],
	.settingDocTitle [ 
		Draw { #backgroundColor: #veryVeryLightGray } ], 
	.settingItemStyle [ 
		Container { #borderWidth: 5 } ],
	.descriptionStyle [ 
		Draw { #backgroundColor: #' , self descriptionBackgroundColor , ' } ]
]'.
]

{ #category : 'initialization' }
StSettingsMainPresenter >> browserTitle [ 

	^ 'Settings Browser'
]

{ #category : 'initialization' }
StSettingsMainPresenter >> connectPresenters [ 

	mainCategoriesPresenter 
		transmitTo: detailsPresenter
		transform: [ : aCategoryItemPresenter | aCategoryItemPresenter node ]
		postTransmission: [ : selectedPage | selectedPage selectFirstPage  ]
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
			add: mainCategoriesPresenter;
			yourself);
		add: detailsPresenter;
		yourself
]

{ #category : 'ports' }
StSettingsMainPresenter >> defaultOutputPort [ 

	^ mainCategoriesPresenter
]

{ #category : 'searching' }
StSettingsMainPresenter >> followPath: aStSettingNode in: aCollection [

	^ aStSettingNode hasParent
		ifTrue: [ (self followPath: aStSettingNode parentNode in: aCollection) ]
		ifFalse: [ aCollection add: aStSettingNode ].

]

{ #category : 'initialization' }
StSettingsMainPresenter >> initialize [

	super initialize.
	self currentApplication
		propertyAt: #settingsTree ifAbsentPut: StSettingsTree new;
		styleSheet: self class styleSheet
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
	detailsPresenter := self instantiate: StSettingsDetailsPresenter on: self.
	
	self initializeFocus.
]

{ #category : 'initialization' }
StSettingsMainPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self browserTitle;
		initialExtent: 1200 @ 700;
		centered
]

{ #category : 'initialization' }
StSettingsMainPresenter >> pagePresenter [ 

	^ detailsPresenter
]
