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
		'manager'
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

{ #category : 'announcements' }
ScopesPresenter >> addScopeToTree: aRBEnvironment [

	model addScope: aRBEnvironment.
	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection sorted
]

{ #category : 'accessing' }
ScopesPresenter >> argumentsListMenu [

	^ self newMenu addGroup: [ :aGroup |
		  aGroup
			  addItem: [ :anItem |
				  anItem
					  name: 'Delete';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self deleteSelectedScope ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Rename';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self openScopeNameDialog ] ];
			  addItem: [ :anItem |
				  anItem
					  name: 'Open on calypso';
					  visibleIf: [ scopesTree selectedItem isScopeNode ];
					  action: [ self openOnCalypso: scopesTree selectedItem value ] ] ]
]

{ #category : 'deletion' }
ScopesPresenter >> deleteSelectedScope [

	scopesTree selectedItems
		select: [ :item | item isScopeNode ]
		thenDo: [ :item | model removeScope: item ].
	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection sorted.
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
			  (model scopes collect: [ :package |
					   ScopeScopeNode on: package ]) asOrderedCollection sorted;
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection | scopesTree toggleSelectedItems ];
		  contextMenu: self argumentsListMenu
]

{ #category : 'accessing' }
ScopesPresenter >> manager [
	^ manager ifNil: [ manager := self scopesManagerClass singleInstance ]
]

{ #category : 'private' }
ScopesPresenter >> newScopeEditor [

	^ ScopeNodesPresenter owner: self on: model
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

{ #category : 'private' }
ScopesPresenter >> openOnCalypso: aScope [
	ClyFullBrowserMorph openOn: aScope
]

{ #category : 'private' }
ScopesPresenter >> openScopeEditor [
	self newScopeEditor open
]

{ #category : 'private' }
ScopesPresenter >> openScopeNameDialog [
	| nameDialog |
	nameDialog := (ScopeNamePresenter on: model)
		              newScope: scopesTree selectedItem value;
		              yourself.
	nameDialog openDialog
		okAction: [ nameDialog submit ];
		cancelAction: [ nameDialog close ]
]

{ #category : 'accessing' }
ScopesPresenter >> refresh [
	scopesTree roots ifEmpty: [ ^ self ].
	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection sorted
]

{ #category : 'announcements' }
ScopesPresenter >> registerEvents [

	self announcer
		when: NewScopeAnnouncement
		do: [ :ann | 
			model addScope: ann scope.
			self addScopeToTree: ann scope ]
		for: self
]

{ #category : 'private' }
ScopesPresenter >> renameSelectedScope [
	self halt.
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

{ #category : 'private' }
ScopesPresenter >> toolbarButtons [
	| buttons |
	buttons := OrderedCollection new.
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #add);
			 help: 'Add a new scope';
			 action: [ self openScopeEditor ];
			 yourself).
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #glamorousTrash);
			 help: 'Delete selected scope';
			 action: [ self deleteSelectedScope ];
			 disable;
			 yourself).

	^ buttons
]
