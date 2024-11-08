"
It represents a setting category page with setting sections and settings. The page was selected from `StSettingsCategoriesPresenter` and it matches a `StSettingsCategoryItemPresenter`.

"
Class {
	#name : 'StSettingsDetailsPresenter',
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
StSettingsDetailsPresenter >> activePage [

	| selectedPage |
	
	selectedPage := notebook selectedPage.
	selectedPage activePresenter
		ifNil: [ selectedPage retrievePresenter ].
	^ selectedPage activePresenter
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> addDefaultGeneralTabFrom: aStSettingNode [
	"Private - Add General Settings default"

	| generalSettingNode |
	
	generalSettingNode := self newSettingNode.
	generalSettingNode item name: self generalTitle.
	generalSettingNode parentName: aStSettingNode name.
	notebook addPage: (SpNotebookPage new
				 icon: (self iconNamed: #smallQuestion);
				 presenterProvider: [ StSettingsNotebookPageContentPresenter on: generalSettingNode ];
				 title: self generalTitle;
				 yourself).
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> addHeaderForSettingsWithoutParent: aSpNotebookPage [
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

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> addSearchResultTabFrom: resultStSettingNodes [
	"Private - Add a tab with search results from resultStSettingNodes in the receiver's notebook"

	| rootSearchResultNode rsSettingNodes rsRootResultNode |
	
	notebook hasPages ifTrue: [ notebook removeAll ].

	rsSettingNodes := resultStSettingNodes copy asOrderedCollection.
	"Create a new settings tree with the results"
	rsRootResultNode := StSettingsTree new nodeList: rsSettingNodes; yourself.
	"Create a new parent node "
	rootSearchResultNode := self newSettingNode
		parentName: 'Results';
		model: rsRootResultNode;
		yourself.
	
	"Set the model of each result node"
	rsSettingNodes do: [ : snc | 
		snc
			parentName: rootSearchResultNode name;
			model: rsRootResultNode ].

	notebook addPage: (self newResultPageOn: rootSearchResultNode).
	self selectFirstPage.


]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> addTabsFrom: aStSettingNode [

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		(nodePresenter := self
			                  instantiate: aSettingNode presenterClass
			                  on: aSettingNode) hasChildren 
			ifTrue: [
				nodePresenter sectionTitleStyle: self sectionTitleString.
				notebook addPage: (SpNotebookPage new
					 icon: (self iconNamed: #smallQuestion);
					 presenterProvider: [ StSettingsNotebookPageContentPresenter on: aSettingNode ];
					 title: aSettingNode label;
					 yourself) ] ]
]

{ #category : 'initialization' }
StSettingsDetailsPresenter >> defaultInputPort [ 

	^ SpModelPort newPresenter: self

]

{ #category : 'layout' }
StSettingsDetailsPresenter >> defaultLayout [ 

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

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> generalTitle [

	^ 'General'
]

{ #category : 'initialization' }
StSettingsDetailsPresenter >> initializePresenters [

	pageTitle := self newLabel.
	notebook := self newNotebook
		            whenSelectedPageChangedDo: [ :presenter | self updateSelectedPage: presenter ];
		            yourself.
	settingDocLabel := self newLabel
		                   addStyle: 'settingDocTitle';
		                   yourself.
	settingDocPresenter := self newText
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> newGeneralSetting: aSpNotebookPage [

	| currentParent generalSettingNode |
	
	currentParent := aSpNotebookPage activePresenter parentNode.
	generalSettingNode := StSettingNode with: PragmaSetting new.
	generalSettingNode item name: self generalTitle.
	generalSettingNode parentName: (currentParent ifNotNil: [ currentParent name ]).
	^ generalSettingNode
]

{ #category : 'TOREMOVE' }
StSettingsDetailsPresenter >> newResultPageOn: aStSettingNode [ 

	^ SpNotebookPage new
		 icon: (self iconNamed: #smallQuestion);
		 presenterProvider: [ self instantiate: StSettingsNotebookPageContentPresenter on: aStSettingNode ];
		 beCloseable;				
		 title: self resultsTitle;
		 yourself
]

{ #category : 'callbacks' }
StSettingsDetailsPresenter >> newSectionNodePresenterFrom: aSettingNode level: anInteger [
	"Private - This is a temporary method until finding a proper solution for 'hand-wired' sections, since some settings declarations are not grouped"

	| nodePresenter |
	nodePresenter := self
		                 instantiate: StSettingSectionPresenter
		                 on: aSettingNode.
	nodePresenter sectionTitleStyle: self sectionTitleString , anInteger asString.
	^ nodePresenter
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> newSettingNode [

	^ StSettingNode with: PragmaSetting new.
]

{ #category : 'initialization' }
StSettingsDetailsPresenter >> notebook [

	^ notebook 
	
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> resultsTitle [

	^ 'Results'
]

{ #category : 'callbacks' }
StSettingsDetailsPresenter >> selectFirstPage [
	
	self notebook selectPageIndex: 1.
	self updateSelectedPage: self notebook selectedPage.
]

{ #category : 'accessing - model' }
StSettingsDetailsPresenter >> setModel: aNode [ 
	"Private - Set the receiver's content iterating recursively starting from aNode"

	settingTree := aNode model childrenOf: aNode.
	pageTitle 
		label: aNode label;
		addStyle: 'pageTitle'.
	notebook removeAll.
	self updatePages: aNode.

]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> updatePages: aStSettingNode [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	self addDefaultGeneralTabFrom: aStSettingNode.
	self addTabsFrom: aStSettingNode.
]

{ #category : 'callbacks' }
StSettingsDetailsPresenter >> updatePresenterGeneralNodes: aCollection [

	| nodePresenter |
	aCollection do: [ :settingNode |
		nodePresenter := self newNodePresenterFrom: settingNode level: 2.
		"Here the owner of each node presenter will be updated to a StSettingsNotebookPageContentPresenter"
		self activePage add: nodePresenter expand: false ]
]

{ #category : 'callbacks' }
StSettingsDetailsPresenter >> updatePresenterTree: aStSettingNode level: anInteger [
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	aStSettingNode allChildren do: [ :aSettingNode |
		| nodePresenter |
		nodePresenter := self
			                 newNodePresenterFrom: aSettingNode
			                 level: anInteger.
		"The activePage here should be a StSettingsNotebookPageContentPresenter"
		self activePage add: nodePresenter expand: false.
		self updatePresenterTree: aSettingNode level: anInteger + 1 ].


]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> updateSelectedPage: aSpNotebookPage [
	"Private - Update the receiver's notebook with aSpNotebookPage. The first time the notebook is opened, a #selectedPage event is triggered and aSpNotebookPage will be nil"

	aSpNotebookPage ifNotNil: [ 
		aSpNotebookPage activePresenter ifNotNil: [ : activePresenter | activePresenter removeAll ].
		self updateSelectedSpecialCases: aSpNotebookPage.
		self updateSelectedPageTree: aSpNotebookPage ]
]

{ #category : 'private' }
StSettingsDetailsPresenter >> updateSelectedPageTree: aSpNotebookPage [ 

	| updatedPage |
	
	updatedPage := 	aSpNotebookPage activePresenter 
		ifNil: [ aSpNotebookPage retrievePresenter ]
		ifNotNil: [ aSpNotebookPage activePresenter ].

	self updatePresenterTree: updatedPage parentNode level: 2
]

{ #category : 'callbacks - tabs' }
StSettingsDetailsPresenter >> updateSelectedSpecialCases: aSpNotebookPage [ 
	"Do not add a 'General' header if we are already in the General tab" 
	
	aSpNotebookPage title = self resultsTitle
		ifFalse: [ 
			aSpNotebookPage title = self generalTitle
				ifFalse: [ self addHeaderForSettingsWithoutParent: aSpNotebookPage ]
				ifTrue: [ self updatePresenterGeneralNodes: (settingTree reject: [ : node | node hasChildren ]) ] ]
]

{ #category : 'callbacks' }
StSettingsDetailsPresenter >> updateSetting: labelString helpText: settingHelpString [

	settingDocLabel label: labelString.
	settingDocPresenter text: settingHelpString.
]
