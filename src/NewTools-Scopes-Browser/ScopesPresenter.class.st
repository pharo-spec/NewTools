"
I am the main Scope Browser presenter. 
I show the list of existing scopes in the system and allow to create, edit and delete scopes.
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
	#category : 'NewTools-Scopes-Browser-GUI',
	#package : 'NewTools-Scopes-Browser',
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
                help: 'Editor for custom Scopes (refactoring environments)';
                order: 10;
					iconName: #smallPushpin
]

{ #category : 'examples' }
ScopesPresenter class >> open [
	ScopeNodesPresenter reset.
	(self on: ScopesManager singleInstance) open
]

{ #category : 'as yet unclassified' }
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
ScopesPresenter >> argumentsListMenu [

	^ self newMenu
		  addGroup: [ :aGroup |
			  aGroup
				  addItem: [ :anItem |
					  anItem
						  name: 'Delete';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  iconName: #glamorousTrash;
						  action: [ self deleteSelectedScope ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Edit';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  iconName: #glamorousEdit;
						  action: [ self editSelectedScope ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Rename';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self openScopeNameDialog ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Open on Calypso';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self openOnCalypso: scopesTree selectedItem value ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Browse';
						  visibleIf: [ scopesTree selectedItem isScopeNode not ];
						  iconName: #glamorousBrowse;
						  action: [ self browseSelectedItem ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Class references';
						  visibleIf: [ scopesTree selectedItem isClassNode ];
						  action: [ self showReferencesToClass: scopesTree selectedItem value] ] ];
		  addGroup: [ :aGroup |
			  aGroup
				  addItem: [ :anItem |
					  anItem
						  name: 'AND';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self andWithScope: scopesTree selectedItem value ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'OR';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self orWithScope: scopesTree selectedItem value ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'NOT';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self notWithScope: scopesTree selectedItem value ] ] ]
]

{ #category : 'menu commands' }
ScopesPresenter >> browseSelectedItem [
	scopesTree selectedItem value browse
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

	| selectedPath |
	selectedPath := scopesTree selection selectedPath.

	(scopesTree selectedItem isNil or: [
		 scopesTree selectedItem isScopeNode not or: [ selectedPath isEmpty ] ])
		ifTrue: [
			self inform: 'select a scope'.
			^ self ].

	(selectedPath at: 1) == 1 ifTrue: [
		self inform: 'You can''t edit this scope'.
		^ self ].

	self newScopeEditor open
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
	self initializeScopesTree
	
]

{ #category : 'initialization' }
ScopesPresenter >> initializeScopesTree [

	^ scopesTree
		  hideColumnHeaders;
		  addColumn: self nodesListColumn;
		  children: [ :each | each children asOrderedCollection ];
		  roots: self scopeNodes;
		  expandRoots;
		  collapsePath: #( 1 );
		  beResizable;
		  activateOnDoubleClick;
		  "whenSelectedItemChangedDo: [ :item | self updateEnabled ];"
		  whenActivatedDo: [ :selection | scopesTree toggleSelectedItems ];
		  contextMenu: self argumentsListMenu
]

{ #category : 'menu commands' }
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
	newScope := anItem value not.
	newName := '~' , anItem value label.
	newScope label: newName.

	self scopesManagerClass singleInstance addScope: newScope.
	self refresh
]

{ #category : 'menu commands' }
ScopesPresenter >> openOnCalypso: aClassOrPackage [

	| browser |
	self halt.
	browser := ClyFullBrowserMorph 
		openOnClass: self class 
		selector: self class selectors anyOne.
		
	"aClassOrPackage isClassOrTrait
		ifTrue: [ browser selectClass: aClassOrPackage ]
		ifFalse: [ browser selectPackage: aClassOrPackage ]"
]

{ #category : 'menu commands' }
ScopesPresenter >> openScopeNameDialog [
	| nameDialog |
	nameDialog := (ScopeNamePresenter on: model)
		              newScope: scopesTree selectedItem value;
		              yourself.
	nameDialog openDialog
		okAction: [ nameDialog submit ];
		cancelAction: [ nameDialog close ]
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
	newScope label: newName.

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

	self announcer weak
		when: ScopeCreatedAnnouncement
		do: [ :ann |
			model addScope: ann scope.
			self addScopeToTree: ann scope ]
		for: self.
	self announcer weak
		when: ScopeEditedAnnouncement
		do: [ self updateScopesTree ]
		for: self
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
	list := model scopes select: [ :each | each value ~= anItem value ].

	anotherScope := self application newSelect
		                display: [ :each | each label ];
		                items: list asArray;
		                title: 'Select another scope';
		                openModal.

	^ anotherScope
]

{ #category : 'initialization' }
ScopesPresenter >> toolbarButtons [

	| buttons |
	buttons := OrderedCollection new.
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #add);
			 help: 'Add a new scope';
			 action: [ self newScopeCreator open ];
			 yourself).

	buttons add: (buttonEdit := self newToolbarButton
			               icon: (self iconNamed: #glamorousEdit);
			               help: 'Edit selected scope';
			               action: [ self editSelectedScope ];
			               yourself).

	buttons add: (buttonDelete := self newToolbarButton
			                 icon: (self iconNamed: #glamorousTrash);
			                 help: 'Delete selected scope';
			                 action: [ self deleteSelectedScope ];
			                 yourself).

	^ buttons
]

{ #category : 'updating' }
ScopesPresenter >> updateEnabled [

	| enabled |
	self flag: 'I should implement this well'.
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
