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
	^ (self on: ScopeModel default) open
]

{ #category : 'layout' }
ScopesPresenter class >> title [
	^ 'Scope Browser'
]

{ #category : 'initialization' }
ScopesPresenter >> initialize [
	super initialize.
	self registerEvents
]

{ #category : 'initialization' }
ScopesPresenter >> initializePresenters [
	scopesTree := self newTable.
	toolbar := self newToolbar.
	self toolbarButtons do: [ :button | toolbar addItem: button ]
]

{ #category : 'private' }
ScopesPresenter >> newScopeEditor [

	^ ScopeNodesPresenter on: model
]

{ #category : 'announcements' }
ScopesPresenter >> registerEvents [
	
	self announcer
		when: NewScopeAnnouncement
		do: [ :ann |
			scopesTree items: (scopesTree items asOrderedCollection add: ann scope; yourself) ]
		for: self
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
