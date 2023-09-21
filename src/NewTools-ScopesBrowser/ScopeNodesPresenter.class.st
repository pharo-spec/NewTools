Class {
	#name : 'ScopeNodesPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'checkedScopeNodes',
		'scopeNodesTree',
		'nodeNameText'
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
	self initializeNodeNameText
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeScopeNodesTree [
	^ scopeNodesTree
		hideColumnHeaders;
		addColumn: self nodesListColumn;
		children: [ :each | each subelements ];
		beMultipleSelection;
		roots: Smalltalk packages sorted;
		beResizable;
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | scopeNodesTree toggleSelectedItems ]
		"contextMenu: self menu"
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

	 

]

{ #category : 'accessing' }
ScopeNodesPresenter >> refreshCheckbox [
	scopeNodesTree refresh
]
