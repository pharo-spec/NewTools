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
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
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
	^ (self on: ScopeModel singleInstance) open
]

{ #category : 'layout' }
ScopesPresenter class >> title [
	^ 'Scope Browser'
]

{ #category : 'announcements' }
ScopesPresenter >> addScopeToTree: aRBEnvironment [

	model addScope: aRBEnvironment.
	scopesTree updateRootsKeepingSelection: model scopes asOrderedCollection
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
		  roots: model scopes asOrderedCollection;
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection | scopesTree toggleSelectedItems ]
]

{ #category : 'private' }
ScopesPresenter >> newScopeEditor [

	^ ScopeNodesPresenter on: model
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

{ #category : 'announcements' }
ScopesPresenter >> registerEvents [

	self announcer
		when: NewScopeAnnouncement
		do: [ :ann | self addScopeToTree: ann scope ]
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
ScopesPresenter >> toolbarButtons [
	| buttons |
	buttons := OrderedCollection new.
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #add);
			 help: 'Add a new scope';
			 action: [ self newScopeEditor open ];
			 yourself).
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #glamorousTrash);
			 help: 'Delete selected scope';
			 action: [ self deleteSelectedScope ];
			 disable;
			 yourself).

	^ buttons
]
