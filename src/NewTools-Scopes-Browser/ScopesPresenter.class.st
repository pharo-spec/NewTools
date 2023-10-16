"
I am the main Scope Browser presenter. 
I show the list of existing scopes in the system and allow to create, edit and delete scopes.
"
Class {
	#name : 'ScopesPresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'scopesTree',
		'toolbar'
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

{ #category : 'world menu' }
ScopesPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
    (aBuilder item: #'Scopes Editor')
                action: [self open];
                parent: #Refactoring;
                help: 'Editor for custom Scopes (refactoring environments)';
                order: 10;
					iconName: #smallPaint
]

{ #category : 'examples' }
ScopesPresenter class >> new [
	^ self on: ScopesManager singleInstance
]

{ #category : 'examples' }
ScopesPresenter class >> open [
	<example>
	^ self new open
]

{ #category : 'as yet unclassified' }
ScopesPresenter class >> refreshAllInstances [
	self allInstances do: [ :each | each refresh ]
]

{ #category : 'specs' }
ScopesPresenter class >> title [
	^ 'Custom Scopes Browser'
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
						action: [
							  self editSelectedScope ] ];
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
						  action: [ self browseSelectedItem ] ] ];
		  addGroup: [ :aGroup |
			  aGroup
				  addItem: [ :anItem |
					  anItem
						  name: 'AND';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self andWithScope: scopesTree selectedItem ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'OR';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self orWithScope: scopesTree selectedItem ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'NOT';
						  visibleIf: [ scopesTree selectedItem isScopeNode ];
						  action: [ self notWithScope: scopesTree selectedItem ] ] ]
]

{ #category : 'menu commands' }
ScopesPresenter >> browseSelectedItem [
	scopesTree selectedItem value browse
]

{ #category : 'menu commands' }
ScopesPresenter >> deleteSelectedScope [

	scopesTree selectedItems
		select: [ :item | item isScopeNode ]
		thenDo: [ :item | model removeScope: item ].
	self updateScopesTree 
]

{ #category : 'menu commands' }
ScopesPresenter >> editSelectedScope [

	(scopesTree selectedItem isNil or: [
		 scopesTree selectedItem isScopeNode not ])
		ifTrue: [ self inform: 'select a scope' ]
		ifFalse: [ self newScopeEditor open ]
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
	
	self initializeScopesTree.
	self toolbarButtons do: [ :button | toolbar addItem: button ]
]

{ #category : 'initialization' }
ScopesPresenter >> initializeScopesTree [

	^ scopesTree
		  hideColumnHeaders;
		  addColumn: self nodesListColumn;
		  children: [ :each | each children sorted ];
		  beMultipleSelection;
		  roots:
			  (model scopes collect: [ :package | ScopeScopeNode on: package ])
				  asOrderedCollection sorted;
		  expandRoots;
		  beResizable;
		  activateOnDoubleClick;
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
	newScope := anItem not.
	newName := '~' , anItem label.
	newScope label: newName.

	self scopesManagerClass singleInstance addScope: newScope.
	self refresh
]

{ #category : 'menu commands' }
ScopesPresenter >> openOnCalypso: aScope [
	ClyFullBrowserMorph openOn: aScope
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
	
	newScope := anItem value perform: aSymbol with: anEnvironment.
	newName := anItem label , aSymbol , anEnvironment label.
	newScope label: newName.

	self scopesManagerClass singleInstance addScope: newScope.
	self refresh
]

{ #category : 'refresh' }
ScopesPresenter >> refresh [
	scopesTree roots ifEmpty: [ ^ self ].
	self updateScopesTree
]

{ #category : 'initialization' }
ScopesPresenter >> registerEvents [

	self announcer
		when: ScopeCreatedAnnouncement
		do: [ :ann |
			model addScope: ann scope.
			self addScopeToTree: ann scope ]
		for: self.
	self announcer
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

	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #glamorousEdit);
			 help: 'Edit selected scope';
			 action: [
				 self editSelectedScope ];
			 yourself).

	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #glamorousTrash);
			 help: 'Delete selected scope';
			 action: [ self deleteSelectedScope ];
			 yourself).

	^ buttons
]

{ #category : 'initialization' }
ScopesPresenter >> updateScopesTree [

	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection sorted
]
