"
Holds application assets and initializers for the Settings Browser.
Currently it is used mainly to access icons and styles.

The main entry point is the `StSettingsApplication>>#start` method.
"
Class {
	#name : 'StSettingsApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'iconMap',
		'settingsTree'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'world menu' }
StSettingsApplication class >> menuSettingsBrowserCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'New Settings Browser')
		parent: #NewToolsMenu;
		label: 'New Settings Browser';
		action: [ self new run ];
		iconName: self taskbarIconName;
		help: 'New Settings Browser';
		order: 3
]

{ #category : 'instance creation' }
StSettingsApplication class >> open [
	<script>

	self new start.
]

{ #category : 'accessing' }
StSettingsApplication >> iconMap [

	^ iconMap
		ifNil: [ iconMap := self initializeIconMap ]
]

{ #category : 'accessing' }
StSettingsApplication >> iconMapAt: aString [ 
	"Answer a <Symbol> specifying an icon name. Defaults to a generic icon if the application does not provide one"

	^ self iconMap 
		at: aString
		ifAbsent: [ #info ]
]

{ #category : 'initialization' }
StSettingsApplication >> initialize [

	super initialize.
	settingsTree := StSettingsTree new.
]

{ #category : 'initialization' }
StSettingsApplication >> initializeIconMap [

	^ Dictionary new
		at: #appearance put: #appearanceIcon;
		at: #codeBrowsing put: #browsingIcon;
		at: #compiler put: #compilerIcon;
		at: #network put: #networkingIcon;
		at: #pharoSystem put: #systemIcon;
		at: #refactoring put: #refactoringIcon;
		at: #shortcuts put: #shortcutsIcon;
		at: #taskitExecution put: #taskitIcon;
		at: #codeEditing put: #texteditorIcon;
		at: #tools put: #toolsIcon;
		yourself
]

{ #category : 'private - factory' }
StSettingsApplication >> newIconProvider [
	
	^ StSettingsBrowserIconProvider new , SpPharoThemeIconProvider new
]

{ #category : 'accessing' }
StSettingsApplication >> settingsTree [
	"Answer the receiver's <StSettingsTree>"

	^ settingsTree
]

{ #category : 'running' }
StSettingsApplication >> start [
	" Private - See superimplementor's comment "

	(StSettingsMainPresenter newApplication: self) open
]

{ #category : 'adding' }
StSettingsApplication >> styleSheet [

	^ SpStyle defaultStyleSheet , 
	    (SpStyleVariableSTONReader fromString: self styleSheetString)

]

{ #category : 'adding' }
StSettingsApplication >> styleSheetString [

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
	.settingItemStyle [ 
		Container { #borderWidth: 5 } ],
	.descriptionStyle [ 
		Draw { #backgroundColor: #' , Smalltalk ui theme windowColor asHexString , ' } ]
]'.
]
