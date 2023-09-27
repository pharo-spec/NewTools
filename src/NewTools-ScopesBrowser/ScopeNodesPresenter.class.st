Class {
	#name : 'ScopeNodesPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'checkedScopeNodes',
		'scopeNodesTree',
		'nodeNameText',
		'cancelButton',
		'saveButton',
		'scopeModel'
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
	checkedScopeNodes add: scopeNode.
	scopeNode subelements isEmptyOrNil ifTrue: [ ^ self ].

	scopeNode subelements do: [ :child |
		checkedScopeNodes add: child ].

	self refreshCheckbox
]

{ #category : 'private' }
ScopeNodesPresenter >> close [
	self window close
]

{ #category : 'private' }
ScopeNodesPresenter >> deactivateItem: scopeNode [
		
	checkedScopeNodes remove: scopeNode.
	scopeNode subelements isEmptyOrNil ifTrue: [ ^ self ].

	scopeNode subelements do: [ :child |
		checkedScopeNodes remove: child ifAbsent: [  ] ].

	self refreshCheckbox.
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initialize [

	super initialize.
	checkedScopeNodes := Set new
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
			  (each subelements sort: [ :n1 :n2 | n1 name < n2 name ]) select: [ :node |
					  (node name beginsWith: nodeNameText text) or: [
							  node package name asLowercase beginsWith: nodeNameText text asLowercase ] ] ];
		  beMultipleSelection;
		  roots: ScopeModel default;
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection | "contextMenu: self menu"
			  scopeNodesTree toggleSelectedItems ]
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
			evaluated: [ :scopeNode | checkedScopeNodes includes: scopeNode ];
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

	scopeNodesTree roots: (Smalltalk packages sorted select: [ :each |
			 (each name beginsWith: nodeNameText text) or: [
				 each definedClasses anySatisfy: [ :class |
					 class name asLowercase beginsWith: nodeNameText text asLowercase ] ] ])
]

{ #category : 'private' }
ScopeNodesPresenter >> refreshCheckbox [
	scopeNodesTree refresh
]

{ #category : 'initialization' }
ScopeNodesPresenter >> saveScope [
	
	self scope updateWithNodes: checkedScopeNodes 
		
]

{ #category : 'accessing' }
ScopeNodesPresenter >> scope [

	^ scopeModel ifNil: [ scopeModel := ScopeModel new ]
]

{ #category : 'accessing' }
ScopeNodesPresenter >> scope: aScopeModel [

	scopeModel := aScopeModel
]
