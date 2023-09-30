Class {
	#name : 'ScopeNodesPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'checkedScopeNodes',
		'scopeNodesTree',
		'nodeNameText',
		'cancelButton',
		'saveButton',
		'scopeModel',
		'model'
	],
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopeNodesPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #scopeNodesTree
		  expand: true
		  fill: true
		  padding: 0;
		  add: #nodeNameText expand: false;
		  add: (SpBoxLayout newLeftToRight 
					add: #saveButton;
					add: #cancelButton;
					yourself)
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		  yourself
]

{ #category : 'layout' }
ScopeNodesPresenter class >> on: aScopeModel [
	^ self basicNew
		scope: aScopeModel;
		initialize;
		yourself
]

{ #category : 'instance creation' }
ScopeNodesPresenter class >> open [
	<script>
	self new open
]

{ #category : 'instance creation' }
ScopeNodesPresenter class >> title [
	^ 'Scope Editor'
]

{ #category : 'private' }
ScopeNodesPresenter >> activateItem: scopeNode [

	self addNode: scopeNode.
	scopeNode children isEmptyOrNil ifTrue: [ ^ self ].
	
	scopeNode children do: [ :child | self addNode: child ]
]

{ #category : 'private' }
ScopeNodesPresenter >> addNode: aNode [

	(checkedScopeNodes anySatisfy: [ :node | aNode value = node value ])
		ifFalse: [ checkedScopeNodes add: aNode ].
	self refreshCheckbox
]

{ #category : 'announcements' }
ScopeNodesPresenter >> announceNewScope: aScope [
	announcer announce: (NewScopeAnnouncement on: aScope)
]

{ #category : 'announcements' }
ScopeNodesPresenter >> announcer: anAnnouncer [
	announcer := anAnnouncer
]

{ #category : 'private' }
ScopeNodesPresenter >> close [
	self window close
]

{ #category : 'private' }
ScopeNodesPresenter >> deactivateItem: scopeNode [

	self removeNode: scopeNode.
	scopeNode children isEmptyOrNil ifTrue: [ ^ self ].
	
	scopeNode children do: [ :child | self removeNode: child ]
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initialize [

	super initialize.
	checkedScopeNodes := Set new.
	
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeButtons [

	saveButton := self newButton
		                label: 'Cancel';
		                action: [ self close ];
		                yourself.
	cancelButton := self newButton
		                label: 'Save';
		                icon: (self iconNamed: #smallSave);
		                action: [ self saveScope ];
		                yourself
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeNodeNameText [
	nodeNameText 
		placeholder: 'Enter a package or class name';
		autoAccept: true;
		whenTextChangedDo: [ :text | self refresh ]
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializePresenters [

	scopeNodesTree := self newScopeTree.
	nodeNameText := self newTextInput.

	self initializeScopeNodesTree.
	self initializeNodeNameText.
	self initializeButtons
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeScopeNodesTree [

	^ scopeNodesTree
		  hideColumnHeaders;
		  addColumn: self nodesListColumn;
		  children: [ :each |
			  each children sorted select: [ :node |
					  (node name asLowercase beginsWith: nodeNameText text asLowercase) or: [
							  node package name asLowercase beginsWith: nodeNameText text asLowercase ] ] ];
		  beMultipleSelection;
		  roots: self model allPackages;
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection | "contextMenu: self menu"
			  scopeNodesTree toggleSelectedItems ]
]

{ #category : 'accessing' }
ScopeNodesPresenter >> model [

	^ model ifNil: [ model := ScopeModel default announcer: announcer ]
]

{ #category : 'private' }
ScopeNodesPresenter >> newScopeTree [
	^ self instantiate: ScopeTreePresenter
]

{ #category : 'private' }
ScopeNodesPresenter >> nodeDescriptionColumn [
	^ SpStringTableColumn evaluated: #name
]

{ #category : 'initialization' }
ScopeNodesPresenter >> nodesListColumn [
	^ SpCompositeTableColumn new
		addColumn: (SpCheckBoxTableColumn new
			beNotExpandable;
			evaluated: [ :scopeNode | checkedScopeNodes anySatisfy: [ :n | n value = scopeNode value ] ];
			onActivation: [ :scopeNode | self activateItem: scopeNode ];
			onDeactivation: [ :scopeNode | self deactivateItem: scopeNode ];
			yourself);
		addColumn: (SpImageTableColumn new
			beNotExpandable;
			evaluated: [ :each | self iconNamed: each scopesIconName ];
			yourself);
		addColumn: self nodeDescriptionColumn;
		yourself
]

{ #category : 'initialization' }
ScopeNodesPresenter >> refresh [

	scopeNodesTree roots: (self model allPackages select: [ :each |
			 (each name asLowercase beginsWith: nodeNameText text asLowercase) or: [
				 each definedClasses anySatisfy: [ :class |
					 class name asLowercase beginsWith: nodeNameText text asLowercase ] ] ])
]

{ #category : 'private' }
ScopeNodesPresenter >> refreshCheckbox [
	scopeNodesTree refresh
]

{ #category : 'private' }
ScopeNodesPresenter >> removeNode: aNode [

	checkedScopeNodes removeAllSuchThat: [ :each |
		each value = aNode value ].
	self refreshCheckbox
]

{ #category : 'initialization' }
ScopeNodesPresenter >> saveScope [
	| newScope |
	self assert: checkedScopeNodes isNotEmpty.
	newScope := self model newScopeFrom: checkedScopeNodes.
	self announceNewScope: newScope.
	self close
		
]
