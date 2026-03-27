"
A welcome topic that will allow quick settings (like theme choice)
"
Class {
	#name : 'StWelcomeSetupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'lightThemePresenter',
		'darkThemePresenter',
		'fullscreenCheckbox',
		'settingsHelpLabel',
		'settingsButton',
		'darkBlueThemePresenter'
	],
	#category : 'NewTools-WelcomeBrowser-Presenters',
	#package : 'NewTools-WelcomeBrowser',
	#tag : 'Presenters'
}

{ #category : 'layout' }
StWelcomeSetupPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		borderWidth: 10;
		spacing: 10;
		add: (self 
			newBox: 'Theme' 
			with: (SpBoxLayout newLeftToRight 
				spacing: 10;
				add: darkBlueThemePresenter;
				add: lightThemePresenter;
				add: darkThemePresenter;
				yourself));
		add: (self 
			newBox: 'Full Screen' 
			with: (SpBoxLayout newTopToBottom 
				add: fullscreenCheckbox;
				yourself));
		add: (self 
			newBox: 'Settings' 
			with: (SpBoxLayout newTopToBottom 
				add: (SpBoxLayout newLeftToRight
					vAlignCenter;
					add: settingsHelpLabel;
					add: settingsButton expand: false;
					yourself);
				yourself));
		yourself
]

{ #category : 'initialization' }
StWelcomeSetupPresenter >> initializePresenters [

	self addStyle: 'welcomeSetup'.

	darkBlueThemePresenter := self newThemePresenter: StWelcomeTheme darkBlue.
	lightThemePresenter := self newThemePresenter: StWelcomeTheme light.
	darkThemePresenter := self newThemePresenter: StWelcomeTheme dark.
	
	fullscreenCheckbox := self newCheckBox 
		label: 'Toggle fullscreen mode';
		state: WorldMorph isFullscreen;
		whenChangedDo: [ :aBoolean | self toggleFullScreen: aBoolean ].
	
	settingsHelpLabel := self newLabel label: self settingsContent.
	settingsButton := self newButton
		addStyle: 'flat'; 
		icon: (self iconNamed: #smallConfiguration);
		label: 'Open';
		action: [ self openSettingsBrowser ];
		yourself
]

{ #category : 'private' }
StWelcomeSetupPresenter >> newBox: aTitle with: aLayout [
	| presenter titleLabel |
	
	presenter := self newPresenter.
	presenter layout: (SpBoxLayout newTopToBottom
		add: (titleLabel := self newLabel) expand: false;
		add: aLayout;
		yourself).
		
	titleLabel label: aTitle.
	titleLabel addStyle: 'title'.
		
	^ presenter
]

{ #category : 'initialization' }
StWelcomeSetupPresenter >> newThemePresenter: aTheme [
	| presenter imagePresenter labelPresenter |
	
	presenter := self newPresenter.
	presenter addStyle: 'welcomeThemeImage'.
	aTheme isActive ifTrue: [ presenter addStyle: 'welcomeThemeSelected' ].
	
	presenter layout: (SpBoxLayout newTopToBottom
		hAlignCenter;
		spacing: 5;
		add: (imagePresenter := presenter newImage);
		add: (labelPresenter := presenter newLabel) expand: false;
		yourself).
		
	labelPresenter label: aTheme label.
	labelPresenter addStyle: 'subtitle'.

	imagePresenter image: aTheme image.
		
 	presenter eventHandler	
		whenMouseDownDo: [ :anEvent | 
			self selectTheme: aTheme.
			presenter addStyle: 'welcomeThemeSelected' ].

	^ presenter
]

{ #category : 'actions' }
StWelcomeSetupPresenter >> openSettingsBrowser [

	(StSettingsBrowser newApplication: self application) open
]

{ #category : 'private' }
StWelcomeSetupPresenter >> selectTheme: aTheme [

	darkBlueThemePresenter removeStyle: 'welcomeThemeSelected'.
	lightThemePresenter removeStyle: 'welcomeThemeSelected'.
	darkThemePresenter removeStyle: 'welcomeThemeSelected'.

	aTheme activate
]

{ #category : 'initialization' }
StWelcomeSetupPresenter >> settingsContent [

	^ 'You can also apply many other settings by opening the Settings Browser'
]

{ #category : 'private' }
StWelcomeSetupPresenter >> toggleFullScreen: aBoolean [

	WorldMorph fullscreen: aBoolean
]
