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
		'notebook',
		'settingTree'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'private' }
StSettingsPagePresenter >> activePage [

	^ notebook selectedPage activePresenter
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> addDefaultGeneralTabFrom: aStSettingNode [
	"Private - Add General Settings default"

	| generalSettingNode |
	
	generalSettingNode := StSettingNode with: PragmaSetting new.
	generalSettingNode item name: self generalTitle.
	generalSettingNode parentName: aStSettingNode name.
	notebook addPage: (SpNotebookPage new
				 icon: (self iconNamed: #smallQuestion);
				 presenterProvider: [ StSettingsPageNotebookPresenter on: generalSettingNode ];
				 title: self generalTitle;
				 yourself).
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> addHeaderForSettingsWithoutParent: aSpNotebookPage [
	"Private - We add a 'General' header (2nd level) for those nodes without parent other than the root"

	| generalSettingNode generalNodePresenter |

	generalSettingNode := self newGeneralSetting: aSpNotebookPage.
	generalNodePresenter := self
		                        newSectionNodePresenterFrom: generalSettingNode
		                        level: 2.
	self activePage 
		add: generalNodePresenter
		expand: false
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> addTabsFrom: aStSettingNode [

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		(nodePresenter := self
			                  instantiate: aSettingNode presenterClass
			                  on: aSettingNode) hasChildren 
			ifTrue: [
				nodePresenter sectionTitleStyle: 'sectionTitleL1'.
				notebook addPage: (SpNotebookPage new
						 icon: (self iconNamed: #smallQuestion);
						 presenterProvider: [ StSettingsPageNotebookPresenter on: aSettingNode ];
					 title: aSettingNode label;
					 yourself) ] ]
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

{ #category : 'callbacks' }
StSettingsPagePresenter >> generalTitle [

	^ 'General'
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

{ #category : 'callbacks' }
StSettingsPagePresenter >> newGeneralSetting: aSpNotebookPage [

	| currentParent generalSettingNode |
	
	currentParent := aSpNotebookPage activePresenter parentNode.
	generalSettingNode := StSettingNode with: PragmaSetting new.
	generalSettingNode item name: self generalTitle.
	generalSettingNode parentName: (currentParent ifNotNil: [ currentParent name ]).
	^ generalSettingNode
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> newNodePresenterFrom: aSettingNode level: anInteger [

	| nodePresenter |
	nodePresenter := self
		                 instantiate: aSettingNode presenterClass
		                 on: aSettingNode.
	nodePresenter sectionTitleStyle: 'sectionTitleL' , anInteger asString.
	^ nodePresenter
]

{ #category : 'callbacks' }
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

	settingTree := aNode model childrenOf: aNode.
	pageTitle 
		label: aNode label;
		addStyle: 'pageTitle'.
	notebook removeAll.
	self updatePages: aNode.

]

{ #category : 'callbacks' }
StSettingsPagePresenter >> updatePages: aStSettingNode [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	self addDefaultGeneralTabFrom: aStSettingNode.
	self addTabsFrom: aStSettingNode.
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> updatePresenterGeneralNodes: aCollection [

	| nodePresenter |
	aCollection do: [ :settingNode |
		nodePresenter := self newNodePresenterFrom: settingNode level: 2.
		self activePage add: nodePresenter expand: false ]
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> updatePresenterTree: aStSettingNode level: anInteger [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		nodePresenter := self
			                 newNodePresenterFrom: aSettingNode
			                 level: anInteger.
		self activePage add: nodePresenter expand: false.
		self updatePresenterTree: aSettingNode level: anInteger + 1 ]
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> updateSelectedPage: aSpNotebookPage [
	
	aSpNotebookPage ifNotNil: [ 
		| tabNode |
		aSpNotebookPage activePresenter removeAll.
		"Do not add a 'General' header if we are already in the General tab" 
		aSpNotebookPage title = self generalTitle
			ifFalse: [ self addHeaderForSettingsWithoutParent: aSpNotebookPage ]
			ifTrue: [ self updatePresenterGeneralNodes: (settingTree reject: [ : node | node hasChildren ]) ].
		tabNode := aSpNotebookPage activePresenter parentNode.
		self updatePresenterTree: tabNode level: 2 ]
]

{ #category : 'callbacks' }
StSettingsPagePresenter >> updateSetting: labelString helpText: settingHelpString [

	settingDocLabel label: labelString.
	settingDocPresenter text: settingHelpString.
]
