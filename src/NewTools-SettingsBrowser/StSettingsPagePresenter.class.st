"
It represents a setting category page with setting sections and settings. The page was selected from `StSettingsCategoriesPresenter` and it matches a `StSettingsCategoryItemPresenter`.

"
Class {
	#name : 'StSettingsPagePresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'pageTitle',
		'settingDocPresenter',
		'settingDocLabel',
		'notebook'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'adding' }
StSettingsPagePresenter >> addHeaderForSettingsWithoutParent: aSpNotebookPage [

	| generalSettingNode currentParent generalNodePresenter |
	aSpNotebookPage activePresenter removeAll.

	currentParent := aSpNotebookPage activePresenter parentNode.
	generalSettingNode := StSettingNode with: PragmaSetting new.
	generalSettingNode item name: 'General'.
	generalSettingNode parentName: (currentParent ifNotNil: [ currentParent name ]).

	generalNodePresenter := self
		                        newSectionNodePresenterFrom: generalSettingNode
		                        level: 2.
	notebook selectedPage activePresenter
		add: generalNodePresenter
		expand: false
]

{ #category : 'initialization' }
StSettingsPagePresenter >> defaultInputPort [ 

	^ SpModelPort newPresenter: self

]

{ #category : 'layout' }
StSettingsPagePresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom 
		add: pageTitle expand: false;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 0.85;
			add: notebook;
			add: (SpBoxLayout newTopToBottom
				spacing: 5;
				add: settingDocLabel expand: false;
				add: settingDocPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
StSettingsPagePresenter >> initializePresenters [

	pageTitle := self newLabel.
	notebook := self newNotebook
		            whenSelectedPageChangedDo: [ :presenter | self updateSelectedPage: presenter ];
		            yourself.
	settingDocLabel := self newLabel
		                   addStyle: 'settingDocTitle';
		                   yourself.
	settingDocPresenter := self newText
]

{ #category : 'accessing' }
StSettingsPagePresenter >> newNodePresenterFrom: aSettingNode level: anInteger [

	| nodePresenter |
	nodePresenter := self
		                 instantiate: aSettingNode presenterClass
		                 on: aSettingNode.
	nodePresenter sectionTitleStyle: 'sectionTitleL' , anInteger asString.
	^ nodePresenter
]

{ #category : 'accessing' }
StSettingsPagePresenter >> newSectionNodePresenterFrom: aSettingNode level: anInteger [
	"Private - This is a temporary method until finding a proper solution for 'hand-wired' sections, since some settings declarations are not grouped"

	| nodePresenter |
	nodePresenter := self
		                 instantiate: StSettingSectionPresenter
		                 on: aSettingNode.
	nodePresenter sectionTitleStyle: 'sectionTitleL' , anInteger asString.
	^ nodePresenter
]

{ #category : 'accessing - model' }
StSettingsPagePresenter >> setModel: aNode [ 
	"Private - Set the receiver's content iterating recursively starting from aNode"

	pageTitle 
		label: aNode label;
		addStyle: 'pageTitle'.
	notebook removeAll.
	self updatePages: aNode.

]

{ #category : 'accessing' }
StSettingsPagePresenter >> updatePages: aStSettingNode [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		nodePresenter := self
			                 instantiate: aSettingNode presenterClass
			                 on: aSettingNode.
		nodePresenter sectionTitleStyle: 'sectionTitleL1'.
		notebook addPage: (SpNotebookPage new
				 icon: (self iconNamed: #smallQuestion);
				 presenterProvider: [ StSettingsPageNotebookPresenter on: aSettingNode ];
				 title: aSettingNode label;
				 yourself) ]
]

{ #category : 'accessing' }
StSettingsPagePresenter >> updatePresenterTree: aStSettingNode level: anInteger [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		nodePresenter := self newNodePresenterFrom: aSettingNode level: anInteger.
		notebook selectedPage activePresenter add: nodePresenter expand: false.
		self updatePresenterTree: aSettingNode level: anInteger + 1 ].
]

{ #category : 'initialization' }
StSettingsPagePresenter >> updateSelectedPage: presenter [
	
	presenter ifNotNil: [ 
		self addHeaderForSettingsWithoutParent: presenter.
		self
			updatePresenterTree: presenter activePresenter parentNode
			level: 2 ]
]

{ #category : 'accessing' }
StSettingsPagePresenter >> updateSetting: labelString helpText: settingHelpString [

	settingDocLabel label: labelString.
	settingDocPresenter text: settingHelpString.
]
