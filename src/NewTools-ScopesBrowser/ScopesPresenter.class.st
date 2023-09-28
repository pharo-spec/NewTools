Class {
	#name : 'ScopesPresenter',
	#superclass : 'SpPresenter',
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
	^ self new open
]

{ #category : 'layout' }
ScopesPresenter class >> title [
	^ 'Scope Browser'
]

{ #category : 'initialization' }
ScopesPresenter >> initialize [
	super initialize.
	announcer := Announcer new.
	self registerEvents
]

{ #category : 'initialization' }
ScopesPresenter >> initializePresenters [
	scopesTree := self newTable.
	toolbar := self newToolbar.
	self toolbarButtons do: [ :button | toolbar addItem: button ]
]

{ #category : 'initialization' }
ScopesPresenter >> registerEvents [
	announcer when: NewScopeAnnouncement do: [ :ann | scopesTree items:  { ann scope } ] for: self
]

{ #category : 'initialization' }
ScopesPresenter >> showScopeEditor [
	| p |
	p := ScopeNodesPresenter new announcer: announcer; yourself.
	p open
]

{ #category : 'accessing' }
ScopesPresenter >> toolbarButtons [
	| buttons |
	buttons := OrderedCollection new.
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #add);
			 help: 'Add a new scope';
			 action: [ self showScopeEditor ];
			 yourself).
	buttons add: (self newToolbarButton
			 icon: (self iconNamed: #glamorousTrash);
			 help: 'Delete selected scope';
			 action: [ self deleteSelectedScope ];
			 disable;
			 yourself).

	^ buttons
]
