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
ScopesPresenter class >> open [
	<example>
	ScopesManager reset.
	^ (self on: ScopesManager singleInstance) open
]

{ #category : 'layout' }
ScopesPresenter class >> title [
	^ 'Scope Browser'
]

{ #category : 'announcements' }
ScopesPresenter >> addScopeToTree: aRBEnvironment [

	model addScope: aRBEnvironment.
	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection
]

{ #category : 'deletion' }
ScopesPresenter >> deleteSelectedScope [

	scopesTree selectedItems
		select: [ :item | item isScopeNode ]
		thenDo: [ :item | model removeScope: item ].
	scopesTree updateRootsKeepingSelection:
		(model scopes collect: [ :scope | ScopeScopeNode on: scope ])
			asOrderedCollection
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
		  whenActivatedDo: [ :selection | scopesTree toggleSelectedItems ]
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
ScopesPresenter >> openScopeEditor [
	self newScopeEditor openModal
]

{ #category : 'announcements' }
ScopesPresenter >> registerEvents [

	self announcer
		when: NewScopeAnnouncement
		do: [ :ann |
			self addScopeToTree: model newScope.
			model resetNewScope ]
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
