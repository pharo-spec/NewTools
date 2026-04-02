"
The Settings Browser it is organized in three main Spec presenters:

- A toolbar which holds operations to be performed (mainly searching), presented by `StSettingsToolbarPresenter`.
- A presenter for ""main categories"", presented by `StSettingsCategoriesPresenter`.
- And a ""details presenter"", presented by `StSettingsPagePresenter`, instantiated when the users selects a main category.

The class side holds application assets (icons and styles) and initializers for the Settings Browser.

"
Class {
	#name : 'StSettingsBrowser',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'toolbarPresenter',
		'detailsPresenter',
		'buttonBarPresenter',
		'exporter',
		'categoriesPresenter',
		'searchResult'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StSettingsBrowser class >> defaultPreferredExtent [

	 ^ 1200 @ 700
]

{ #category : 'world menu' }
StSettingsBrowser class >> menuSettingsBrowserCommandOn: aBuilder [
	<worldMenu>
		
	(aBuilder item: #Settings)
		parent: #Pharo;
		order: 1;
		iconName: #smallConfiguration;
		action: [ (self newApplication: StPharoApplication current) open ];
		keyText: 'o, s';
		help: 'Opens a Settings Browser which allows you to alter many system settings.'
]

{ #category : 'accessing' }
StSettingsBrowser >> addSearchResultFrom: colOfStSettingNode [

	searchResult := colOfStSettingNode.
	categoriesPresenter roots: colOfStSettingNode asOrderedCollection
]

{ #category : 'accessing' }
StSettingsBrowser >> addSearchResultTabFrom: colOfStSettingNode [

	categoriesPresenter items: colOfStSettingNode asOrderedCollection
]

{ #category : 'initialization' }
StSettingsBrowser >> connectPresenters [ 

	categoriesPresenter transmitTo: detailsPresenter
]

{ #category : 'transmission' }
StSettingsBrowser >> defaultInputPort [ 

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ detailsPresenter ];
		yourself
]

{ #category : 'layout' }
StSettingsBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: buttonBarPresenter expand: false;
		add: (SpPanedLayout newLeftToRight
			positionOfSlider: 250;
			add: (SpBoxLayout newTopToBottom
				add: toolbarPresenter expand: false;
				add: categoriesPresenter;
				yourself);
			add: detailsPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
StSettingsBrowser >> exportSettings [
	| nodes actions |

	nodes := self settingsTree nodeList.
	actions := nodes 
		collect: [ : e | e item exportSettingAction ]
		thenReject: [ : e | e isNil ].
		
	self exporter exportAllSettings: actions.
	self inform: 'Settings were exported to ' , self exporter exportedFileFullName.
	buttonBarPresenter enable
]

{ #category : 'accessing' }
StSettingsBrowser >> exporter [

	^ exporter
]

{ #category : 'private' }
StSettingsBrowser >> findPathOf: pathCollection on: itemCollection [
	| first node |
	
	pathCollection ifEmpty: [ ^ #() ].
	
	first := pathCollection first.
	
	node := itemCollection detect: [ :each | each name = first ] ifNone: [ nil ].
	node ifNil: [ ^ #() ].
	
	^ { node }, (self 
		findPathOf: pathCollection allButFirst
		on: node allChildren)
]

{ #category : 'searching' }
StSettingsBrowser >> followPath: aStSettingNode in: aCollection [

	^ aStSettingNode hasParent
		ifTrue: [ (self followPath: aStSettingNode parentNode in: aCollection) ]
		ifFalse: [ aCollection add: aStSettingNode ].

]

{ #category : 'initialization' }
StSettingsBrowser >> initialize [

	super initialize.
	exporter := StSettingsExporter new
]

{ #category : 'initialization' }
StSettingsBrowser >> initializeButtonBar [

	buttonBarPresenter := self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: (self newToolbarButton
			addStyle: 'large';
			icon: (self iconNamed: #openFromUrl);
			label: 'Load';
			help: 'Load settings from a file';
			action: [ self loadSettings ];
			enabled: self settingsTree hasSettingsFile;
			yourself);
		add: (self newToolbarButton
			icon: (self application iconNamed: #save);
			label: 'Export';
			help: 'Save settings into a file';
			action: [ self exportSettings ];
			yourself);
		yourself
]

{ #category : 'initialization' }
StSettingsBrowser >> initializeFocus [

	self focusOrder 
		add: toolbarPresenter;
		add: categoriesPresenter;
		add: detailsPresenter
]

{ #category : 'initialization' }
StSettingsBrowser >> initializePresenters [

	self addStyle: 'stSettingsBrowser'.

	toolbarPresenter := self instantiate: StSettingsToolbarPresenter on: self.
	
	categoriesPresenter := self newEasyTreeListView
		display: [ :aNode | aNode label ];
		children: [ :aNode | 
			"show just two levels as this is annoying otherwise"
			(aNode level < 2) 
				ifTrue: [ self sortNodes: (aNode allChildren select: [ :each | each hasChildren ]) ]
				ifFalse: [ #() ] ];
		yourself.
	
	detailsPresenter := self instantiate: StSettingDetailPresenter.
	
	self initializeButtonBar.
	self initializeFocus
]

{ #category : 'loading' }
StSettingsBrowser >> loadSettings [
	"Load the settings from the system settings file, if exists"

	self settingsTree settingsFileDirectory
		ifNotNil: [ : settingsDirectory | 
			settingsDirectory hasFiles 
				ifTrue: [ self loadSettingsFrom: (self selectDialog: settingsDirectory files) ]
				ifFalse: [ self inform: 'No settings files were found in the settings directory' ] ]
]

{ #category : 'loading' }
StSettingsBrowser >> loadSettingsFrom: aFileReference [ 

	self settingsTree persistence fileReference: aFileReference.
	self settingsTree updateSettingNodes.
	self inform: 'Settings were loaded from ' , aFileReference fullName
]

{ #category : 'initialization' }
StSettingsBrowser >> pagePresenter [ 

	^ detailsPresenter
]

{ #category : 'accessing' }
StSettingsBrowser >> resetSearchResult [

	searchResult ifNil: [ ^ self ].
	
	searchResult := nil.
	self updatePresenter
]

{ #category : 'accessing' }
StSettingsBrowser >> rootItems [

	^ self sortNodes: self settingsTree treeRoots
]

{ #category : 'accessing' }
StSettingsBrowser >> select: aString [
	| node path |

	node := self settingsTree nodeList 
		detect: [ :each | each name = aString ]
		ifNone: [ nil ].
	node ifNil: [ ^ self ].
	
	path := categoriesPresenter selectionMode pathOf: node.
		
	categoriesPresenter selectPath: path scrollToSelection: true. 
]

{ #category : 'execution' }
StSettingsBrowser >> selectDialog: fileReferneces [

	^ SpSelectDialog new
		  title: 'Settings Browser Selector';
		  message: 'Select a Stored Settings File';
		  items: fileReferneces;
		  display: [ :each | each basename ];
		  displayIcon: [ :each | self iconNamed: each systemIconName ];
		  openModal
]

{ #category : 'accessing' }
StSettingsBrowser >> selectPath: aCollection [
	"selects a path of the settings tree (by name).
	 e.g. aSettingsBrowser selectPath: #(tools epicea)"
	
	| pathItems |

	pathItems := self findPathOf: aCollection on: categoriesPresenter roots.
	pathItems isEmptyOrNil ifTrue: [ ^ self ].
	
	categoriesPresenter
		selectPathByItems: pathItems 
		scrollToSelection: true
]

{ #category : 'private' }
StSettingsBrowser >> sortNodes: aCollection [ 

	^ aCollection sorted: #order ascending, #label ascending
]

{ #category : 'initialization' }
StSettingsBrowser >> updatePresenter [

	categoriesPresenter 
		roots: self rootItems;
		expandRoots
]

{ #category : 'initialization' }
StSettingsBrowser >> windowTitle [ 

	^ 'Settings Browser'
]
