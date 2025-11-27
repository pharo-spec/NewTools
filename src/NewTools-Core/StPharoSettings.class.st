Class {
	#name : 'StPharoSettings',
	#superclass : 'Object',
	#classVars : [
		'CodeShowLineNumbers',
		'ToolbarDisplayMode'
	],
	#category : 'NewTools-Core-Application',
	#package : 'NewTools-Core',
	#tag : 'Application'
}

{ #category : 'settings' }
StPharoSettings class >> codeShowLineNumbers [
	"Defines if code editors will display line numbers"

	^ CodeShowLineNumbers ifNil: [
		  CodeShowLineNumbers := StPharoApplication defaultCodeShowLineNumbers ]
]

{ #category : 'settings' }
StPharoSettings class >> codeShowLineNumbers: aBoolean [

	CodeShowLineNumbers := aBoolean.
	self codeSupportAnnouncer announce: SpCodeShowLineNumbersChanged new
]

{ #category : 'defaults' }
StPharoSettings class >> defaultToolbarDisplayMode [

	^ SpToolbarDisplayMode modeIconAndLabel
]

{ #category : 'world menu' }
StPharoSettings class >> openPharoAbout [

	| about |
	about := String cr , 'Pharo ' , SystemVersion current dottedMajorMinorPatch , String cr,
		'Build information: ', SystemVersion current asString, String cr,
		SystemVersion current date asString , String cr, String cr,
		Smalltalk licenseString.


	SpInformDialog new
		title: 'About Pharo';
		icon: (self iconNamed: #pharo);
		label: about;
		acceptLabel: 'Close';
		openDialog
]

{ #category : 'world menu' }
StPharoSettings class >> pharoAboutOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'About...')
		order: 99;
		iconName: #smallInfo;
		parent: #Help;
		help: 'Informations about this version of Pharo.';
		action: [ self openPharoAbout ]
]

{ #category : 'settings' }
StPharoSettings class >> settingsOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #codeShowLineNumbers)
		parent: #tools;
		order: 0;
		default: self codeShowLineNumbers;
		target: self;
		description: 'If code panels will display line numbers';
		label: 'Show line numbers in code panels'.

	(aBuilder pickOne: #toolbarDisplayMode)
		parent: #tools;
		order: 1;
		default: self toolbarDisplayMode;
		target: self;
		domainValues: (SpToolbarDisplayMode all collect: [ :each | each label -> each ]);
		description: 'Toolbars will be displayed in icon+label, icon, or label mode.';
		label: 'Toolbar display mode'		
]

{ #category : 'settings' }
StPharoSettings class >> toolbarDisplayMode [
	"Defines how the toolbar will be displayed (icons+text, icons, text)"

	^ ToolbarDisplayMode ifNil: [ ToolbarDisplayMode := self defaultToolbarDisplayMode ]
]

{ #category : 'settings' }
StPharoSettings class >> toolbarDisplayMode: aMode [
	"self toolbarDisplayMode: SpToolbarDisplayMode modeIcon"
	
	ToolbarDisplayMode := aMode
]
