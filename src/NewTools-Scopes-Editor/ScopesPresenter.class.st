"
I am the main Scopes Editor presenter. 
I show the list of existing scopes in the system and allow users to create, edit and delete scopes.
"
Class {
	#name : 'ScopesPresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'scopesTree',
		'toolbar',
		'buttonEdit',
		'buttonDelete'
	],
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopesPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		  add: #toolbar
		  expand: false
		  fill: false
		  padding: 0;
		  add: #scopesTree;
		  yourself
]

{ #category : 'examples' }
ScopesPresenter class >> example [
	<example>
	self open
]

{ #category : 'world menu' }
ScopesPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
    (aBuilder item: #'Scopes Editor')
                action: [self open];
                parent: #Refactoring;
                help: 'Editor for user defined Scopes (Scopes are used as environments when performing refactorings)';
                order: 10;
					iconName: #smallPushpin
]

{ #category : 'specs' }
ScopesPresenter class >> newInstance [
	ScopeNodesPresenter reset.
	^ self on: ScopesManager singleInstance
]

{ #category : 'opening' }
ScopesPresenter class >> open [

	self newInstance open
]

{ #category : 'opening' }
ScopesPresenter class >> openSelecting: aScope [

	(self newInstance
		 selectScope: aScope;
		 yourself) open
]

{ #category : 'actions' }
ScopesPresenter class >> refreshAllInstances [
	<script>
	self allInstances do: [ :each | each refresh ]
]

{ #category : 'specs' }
ScopesPresenter class >> title [
	^ 'Scopes Editor'
]

{ #category : 'api' }
ScopesPresenter >> addScopeToTree: aRBEnvironment [

	model addScope: aRBEnvironment.
	self updateScopesTree
]

{ #category : 'operations' }
ScopesPresenter >> andWithScope: anItem [
	self performOperation: #& with: anItem
]

{ #category : 'menu commands' }
ScopesPresenter >> argumentsListActions [

	^ SpActionGroup new 
		addActionWith: [ :anItem | anItem
			name: 'Delete';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			iconName: #glamorousTrash;
			action: [ self deleteSelectedScope ] ];
		addActionWith: [ :anItem | anItem
			name: 'Edit';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			iconName: #glamorousEdit;
			action: [ self editSelectedScope ] ];
		addActionWith: [ :anItem | anItem
			name: 'Rename';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			action: [ self renameSelectedScope ] ];
		addActionWith: [ :anItem | anItem
			name: 'Inspect';
			iconName: #glamorousSearch;
			action: [ scopesTree selectedItem inspect ] ];
		addActionWith: [ :anItem | anItem
			name: 'Open in browser';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			action: [ self openOnCalypso: scopesTree selectedItem value ] ];
		addActionWith: [ :anItem | anItem 
			name: 'Browse';
			actionEnabled: [ scopesTree selectedItem isScopeNode not ];
			iconName: #glamorousBrowse;
			action: [ self browseSelectedItem ] ];
		addActionWith: [ :anItem | anItem
			name: 'Class references';
			actionEnabled: [ scopesTree selectedItem isClassNode ];
			action: [ self showReferencesToClass: scopesTree selectedItem value ] ];
		addActionWith: [ :anItem | anItem
			name: 'OR';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			action: [ self orWithScope: scopesTree selectedItem ] ];
		addActionWith: [ :anItem | anItem
			name: 'AND';
			actionEnabled: [ scopesTree selectedItem isScopeNode ];
			action: [ self andWithScope: scopesTree selectedItem ] ];
		yourself
]

{ #category : 'menu commands' }
ScopesPresenter >> argumentsListMenu [

	^ self newMenu addGroup: [ :aGroup |
		  aGroup
			  addItem: [ :anItem |
				  anItem
					  name: 'Delete';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  iconName: #trash;
					  action: [ self deleteSelectedScope ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Edit';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  iconName: #edit;
					  action: [ self editSelectedScope ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Rename';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self renameSelectedScope ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Inspect';
					  iconName: #search;
					  action: [ scopesTree selectedItem inspect ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Open on Calypso';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self openOnCalypso: scopesTree selectedItem value ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Browse';
					  visibleIf: [ scopesTree selectedItem isScopeNode not ];
					  iconName: #browse;
					  action: [ self browseSelectedItem ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Class references';
					  visibleIf: [ scopesTree selectedItem isClassNode ];
					  action: [
						  self showReferencesToClass: scopesTree selectedItem value ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'OR';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self orWithScope: scopesTree selectedItem ] ];
			addItem: [ :anItem |
				  anItem
					  name: 'AND';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self andWithScope: scopesTree selectedItem ] ]";
			    
			addItem: [ :anItem |
				  anItem
					  name: 'NOT';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self notWithScope: scopesTree selectedItem ] ] "]
]

{ #category : 'menu commands' }
ScopesPresenter >> browseSelectedItem [
	scopesTree selectedItem value browse
]

{ #category : 'menu commands' }
ScopesPresenter >> createNewScope [

	self newScopeCreator open
]

{ #category : 'menu commands' }
ScopesPresenter >> deleteSelectedScope [

	| item selectedPath originallySelectedPath |
	originallySelectedPath := scopesTree selection selectedPath.

	item := scopesTree selectedItem.
	(item isNil or: [
		 item isScopeNode not or: [ originallySelectedPath isEmpty ] ])
		ifTrue: [
			self inform: 'select a scope'.
			^ self ].

	(originallySelectedPath at: 1) == 1 ifTrue: [
		self inform: 'You can''t delete this scope'.
		^ self ].

	model removeScope: item value.
	selectedPath := scopesTree selection selectedPath at: 1.

	self updateScopesTree.

	scopesTree selectPath: { (selectedPath - 1) } asArray
]

{ #category : 'menu commands' }
ScopesPresenter >> editSelectedScope [

	| selectedPath selectedItem presenter |
	selectedPath := scopesTree selection selectedPath.
	selectedItem := scopesTree selectedItem.
	(selectedItem isNil or: [
		 selectedItem isScopeNode not or: [ selectedPath isEmpty ] ])
		ifTrue: [
			self inform: 'select a scope'.
			^ self ].

	(selectedPath at: 1) == 1 ifTrue: [
		self inform: 'You can''t edit the full environment scope'.
		^ self ].
	
	presenter := self newScopeEditor open.
	presenter withWindowDo: [ :w | w title: 'Editing scope "', selectedItem value label,'"' ]
]

{ #category : 'menu commands' }
ScopesPresenter >> getScopeName [

	| label |
	label := self getNameFromUser.
	(self validateNameBlock value: label)
		ifTrue: [ ^ model nameWithIndex: label ]
		ifFalse: [
			self inform: 'Name can''t be empty or contain spaces'.
			^ nil ]
]

{ #category : 'initialization' }
ScopesPresenter >> initialize [

	super initialize.
	self registerEvents
]

{ #category : 'initialization' }
ScopesPresenter >> initializePresenters [
	scopesTree := self newScopeTree.
	toolbar := self newToolbar.
	
	self toolbarButtons do: [ :button | toolbar addItem: button ].
	self initializeScopesTree.
	
]

{ #category : 'initialization' }
ScopesPresenter >> initializeScopesTree [

	^ scopesTree
		  hideColumnHeaders;
		  addColumn: self nodesListColumn;
		  children: [ :each | each children asOrderedCollection ];
		  roots: self scopeNodes;
		  lazilyComputeChildren;
		  beResizable;
		  activateOnDoubleClick;
		  "whenSelectedItemChangedDo: [ :item | self updateEnabled ];"
		  whenActivatedDo: [ :selection | scopesTree toggleSelectedItems ];
		  contextMenu: self argumentsListMenu
]

{ #category : 'private' }
ScopesPresenter >> newScopeCreator [

	^ ScopeNodesPresenter owner: self on: model
]

{ #category : 'private' }
ScopesPresenter >> newScopeEditor [

	^ self newScopeCreator
		  scope: scopesTree selectedItem value;
		  yourself
]

{ #category : 'initialization' }
ScopesPresenter >> nodeDescriptionColumn [

	^ SpStringTableColumn evaluated: #label
]

{ #category : 'initialization' }
ScopesPresenter >> nodesListColumn [

	^ SpCompositeTableColumn new
		  addColumn: (SpImageTableColumn new
				   beNotExpandable;
				   evaluated: [ :each | self iconNamed: each scopesIconName ];
				   yourself);
		  addColumn: self nodeDescriptionColumn;
		  yourself
]

{ #category : 'operations' }
ScopesPresenter >> notWithScope: anItem [

	| newScope newName |
	
	newScope := anItem not.
	newName := '~' , anItem value label.
	newScope label: (model nameWithIndex: newName).

	self scopesManagerClass singleInstance addScope: newScope.
	self refresh
]

{ #category : 'menu commands' }
ScopesPresenter >> openOnCalypso: aClassOrPackage [

	| scope |
	
	scope := ClyScopedSystemEnvironment currentImage copy
		         scope: aClassOrPackage;
		         yourself.

	ClyFullBrowserMorph
		           openOn: (ClyNavigationEnvironment defaultOver: scope)
		           withState: [  ]
]

{ #category : 'operations' }
ScopesPresenter >> orWithScope: anItem [
	self performOperation: #| with: anItem
]

{ #category : 'operations' }
ScopesPresenter >> performOperation: aSymbol with: anItem [

	| anEnvironment newScope newName |
	anEnvironment := self selectAnotherScopeWhitout: anItem.
	anEnvironment ifNil: [ ^ self ].

	newScope := anItem perform: aSymbol with: anEnvironment.
	newName := anItem label , aSymbol , anEnvironment label.
	newScope label: (model nameWithIndex: newName).

	self scopesManagerClass singleInstance addScope: newScope.
	self refresh
]

{ #category : 'menu commands' }
ScopesPresenter >> referencesToSelectedClass [

	| scope browser query class |
	class := scopesTree selectedItem value.
	scope := ClySystemEnvironmentScope
		         of: ClySystemEnvironment currentImage
		         in: ClyNavigationEnvironment currentImage.

	browser := (ClyFullBrowserMorph on:
		            ClyNavigationEnvironment currentImage)
		           ensureInitialState.

	query := (ClyClassReferencesQuery of: class)
		         scope: scope;
		         yourself.

	browser spawnQueryBrowserOn: query
]

{ #category : 'refresh' }
ScopesPresenter >> refresh [
	scopesTree roots ifEmpty: [ ^ self ].
	self updateScopesTree
]

{ #category : 'initialization' }
ScopesPresenter >> registerEvents [

	self announcer subscriptions reset.

	self announcer weak
		when: ScopeCreatedAnnouncement
		do: [ :ann |
			self addScopeToTree: ann scope.
			self selectScope: ann scope ]
		for: self.
	self announcer weak
		when: ScopeEditedAnnouncement
		do: [ self updateScopesTree ]
		for: self
]

{ #category : 'menu commands' }
ScopesPresenter >> renameSelectedScope [

	| scope label |
	scope := scopesTree selectedItem value.
	label := self getScopeName.
	label ifNotNil: [
		scope label: label.
		self refresh ]
]

{ #category : 'initialization' }
ScopesPresenter >> scopeListColumn [

	^ SpCompositeTableColumn new
		  addColumn: (SpImageTableColumn new
				   beNotExpandable;
				   evaluated: [ :each | self iconNamed: each scopesIconName ];
				   yourself);
		  addColumn: self nodeDescriptionColumn;
		  yourself
]

{ #category : 'initialization' }
ScopesPresenter >> scopeNodes [
	^ { (ScopeScopeNode on: model defaultScope) } asOrderedCollection
		  addAll: (model scopes collect: [ :s | ScopeScopeNode on: s ])
				  asOrderedCollection sorted;
		  yourself
]

{ #category : 'private' }
ScopesPresenter >> scopesManagerClass [
	^ ScopesManager
]

{ #category : 'operations' }
ScopesPresenter >> selectAnotherScopeWhitout: anItem [

	| anotherScope list |
	list := {model defaultScope} asOrderedCollection.
	list addAll: (model scopes select: [ :each | each value ~= anItem value ]).

	anotherScope := self application newSelect
		                display: [ :each | each label ];
		                items: list asArray;
		                title: 'Select another scope';
		                openModal.

	^ anotherScope
]

{ #category : 'initialization' }
ScopesPresenter >> selectScope: aScope [

	| item |
	item := (scopesTree roots select: [ :root | root value = aScope ])
		        at: 1.
	scopesTree selectItem: item
]

{ #category : 'initialization' }
ScopesPresenter >> toolbarButtons [

	| buttons |
	buttons := OrderedCollection new.
	
	buttons add: (self newToolbarPopoverButton
			 icon: (self iconNamed: #add);
			 help: 'Add a new scope';
			 content: [
				 self newToolbar
					 addItem: (self newToolbarButton
							  help: 'Add a new scope from classes and packages';
							  label: 'Classes and packages';
							  action: [ self createNewScope ];
							  yourself)";
					 addItem: (self newToolbarButton
							  help: 'Add a new scope from class hierarchies';
							  label: 'Class hierarchy';
							  action: [ self createNewScope ];
							  yourself)";
					 yourself ];
			 yourself).

	buttons add: (buttonEdit := self newToolbarButton
			               icon: (self iconNamed: #edit);
			               help: 'Edit selected scope';
			               action: [ self editSelectedScope ];
			               yourself).

	buttons add: (buttonDelete := self newToolbarButton
			                 icon: (self iconNamed: #trash);
			                 help: 'Delete selected scope';
			                 action: [ self deleteSelectedScope ];
			                 yourself).

	^ buttons
]

{ #category : 'updating' }
ScopesPresenter >> updateEnabled [

	| enabled |
	
	"The first scope cannot be edited nor deleted because it is the full image environment"
	enabled := scopesTree selectedItem isNotNil and: [
		           scopesTree selection selectedPath ~= #( 1 ) ].
	
	buttonEdit ifNotNil: [:btn | btn enabled: enabled].
	buttonDelete ifNotNil: [:btn | btn enabled: enabled]
]

{ #category : 'initialization' }
ScopesPresenter >> updateScopesTree [

	scopesTree updateRootsKeepingSelection: self scopeNodes
]
