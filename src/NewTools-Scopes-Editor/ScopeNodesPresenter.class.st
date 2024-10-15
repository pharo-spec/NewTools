"
I display a tree with all the available packages and classes to create or edit a scope
"
Class {
	#name : 'ScopeNodesPresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'checkedScopeNodes',
		'scopeNodesTree',
		'nodeNameText',
		'cancelButton',
		'saveButton',
		'saveAsButton',
		'allScopeNodeTreeRoots',
		'scope'
	],
	#classVars : [
		'LastSearch'
	],
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
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
				   add: #cancelButton;
				   add: #saveButton;
				   add: #saveAsButton;
				   yourself)
		  withConstraints: [ :constraints |
		  constraints height: self toolbarHeight ];
		  yourself
]

{ #category : 'layout' }
ScopeNodesPresenter class >> lastSearchText [
	^ LastSearch 
]

{ #category : 'layout' }
ScopeNodesPresenter class >> reset [
	LastSearch := nil
]

{ #category : 'specs' }
ScopeNodesPresenter class >> title [
	^ 'Scope creator'
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> activateItem: scopeNode [

	self addNode: scopeNode
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> addNode: aNode [

	checkedScopeNodes add: aNode.
	self refreshNodeCheckbox: aNode
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> addSelectedItemClassHierarchy [	
	| class supers suprclass node |
	node := scopeNodesTree selectedItem.
	self activateItem: node.
	class := node value.
	class = Object ifTrue: [ ^ self ].
	
	suprclass := class superclass.
	supers := class allSuperclasses.
	supers := supers select: [ :each | each value ~= Object and: each value ~= ProtoObject ].

	self allScopeNodeTreeRoots do: [ :root |
		root children do: [ :child |
			(supers includes: child value) ifTrue: [
				self activateItem: child ] ] ]
]

{ #category : 'accessing' }
ScopeNodesPresenter >> allScopeNodeTreeRoots [

	^ allScopeNodeTreeRoots ifNil: [
		  allScopeNodeTreeRoots := model allPackagesInEnvironment collect: [
			                           :package | ScopePackageNode on: package ] ]
]

{ #category : 'announcements' }
ScopeNodesPresenter >> announceScopeCreated: aScope [

	self announcer announce: (ScopeCreatedAnnouncement new
			 scope: aScope;
			 yourself)
]

{ #category : 'announcements' }
ScopeNodesPresenter >> announceScopeEdited [
	
	self announcer announce: (ScopeEditedAnnouncement new)
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> argumentsListActions [

	^ SpActionGroup new
		addActionWith: [ :anItem | anItem
			name: 'Check all Cmd-a';
			iconName: #glamorousAccept;
			action: [ self checkAll ] ];
		addActionWith: [ :anItem | anItem
			name: 'Unheck all';
			shortcutKey: $u actionModifier;
			iconName: #glamorousAccept;
			action: [ self uncheckAll ] ];
		addActionWith: [ :anItem | anItem
			name: 'Add class hierarchy (flattened)';
			actionEnabled: [ scopeNodesTree selectedItem isClassNode ];
			iconName: #hierarchy;
			action: [ self addSelectedItemClassHierarchy ] ];
		addActionWith: [ :anItem | anItem
			name: 'Browse';
			actionEnabled: [ scopeNodesTree selectedItem isNotNil ];
			iconName: #glamorousBrowse;
			action: [ self browseSelectedItem ] ];
		addActionWith: [ :anItem | anItem
  			name: 'Class references';
  			actionEnabled: [ scopeNodesTree selectedItem isClassNode ];
  			iconName: #glamorousBrowse;
  			action: [ self showReferencesToClass: scopeNodesTree selectedItem value ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: $a actionModifier;
			action: [ self checkAll ] ];
		yourself
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> browseSelectedItem [
	scopeNodesTree selectedItem value browse
]

{ #category : 'initialization' }
ScopeNodesPresenter >> checkAll [

	scopeNodesTree roots do: [ :root |
		(checkedScopeNodes includes: root) ifFalse: [
			self activateItem: root ] ]
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> checkSelectedNodes [

	scopeNodesTree selection selectedItems do: [ :item |
		self activateItem: item ].

	self refresh
]

{ #category : 'announcements' }
ScopeNodesPresenter >> checkedItems [
	^ checkedScopeNodes collect: [ :node | node value ]
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> close [
	self window close
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> deactivateItem: scopeNode [

	self removeNode: scopeNode
]

{ #category : 'initialization' }
ScopeNodesPresenter >> editScope: aScope [
	model editScope: aScope withNodes: (checkedScopeNodes collect: [:each | each value]).
	self announceScopeEdited
]

{ #category : 'testing' }
ScopeNodesPresenter >> editing [
	^ scope isNotNil
]

{ #category : 'menu commands' }
ScopeNodesPresenter >> getScopeName [

	| label validate |
	validate := self validateNameBlock.

	label := nodeNameText text trim.
	(validate value: label) ifTrue: [ ^ model nameWithIndex: label ].

	label := self getNameFromUser.
	(validate value: label) 
		ifTrue: [ ^ model nameWithIndex: label ].
	
	^ nil
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initialize [

	super initialize.
	checkedScopeNodes := Set new
	
	
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeButtons [

	cancelButton := self newButton
		                label: 'Cancel';
		                action: [ self close ];
		                yourself.

	saveAsButton := self newButton
		                label: 'Save as...';
		                icon: (self iconNamed: #smallSaveAs);
		                action: [ self saveScopeAs ];
		                yourself.

	saveButton := self newButton
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
		whenTextChangedDo: [ :text |
			LastSearch := nodeNameText text.
			self refresh ].
	LastSearch ifNotNil: [ nodeNameText text: LastSearch ]
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializePresenters [

	scopeNodesTree := self newScopeTree.
	nodeNameText := self newTextInput.

	self initializeScopeNodesTree.
	self initializeNodeNameText.
	self initializeButtons
]

{ #category : 'announcements' }
ScopeNodesPresenter >> initializeScope [

	^ model newScopeFrom: self checkedItems
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeScopeNodesTree [

	scopeNodesTree
		hideColumnHeaders;
		addColumn: self nodesListColumn;
		children: [ :each |
			(each children select: [ :node |
					 self node: node matches: nodeNameText text ])
				asOrderedCollection sorted ];
		beMultipleSelection;
		roots: self allScopeNodeTreeRoots asOrderedCollection sorted;
		beResizable;
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | scopeNodesTree toggleSelectedItems ];
		actions: self argumentsListActions.

	^ scopeNodesTree
]

{ #category : 'announcements' }
ScopeNodesPresenter >> newScopeFrom: items [
	"an item is either a class or a package"
	^ model newScopeFrom: items
]

{ #category : 'initialization' }
ScopeNodesPresenter >> node: aNode matches: aString [

	^ (aNode name asLowercase beginsWith: aString asLowercase) or:
		  ((aNode package name asLowercase beginsWith: aString asLowercase)
			   or: [
				   aNode definedClasses anySatisfy: [ :class |
					   class name asLowercase beginsWith:
						   nodeNameText text asLowercase ] ])
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> nodeDescriptionColumn [
	^ SpStringTableColumn evaluated: #name
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> nodesListColumn [

	^ SpCompositeTableColumn new
		  addColumn: (SpCheckBoxTableColumn new
				   beNotExpandable;
				   evaluated: [ :scopeNode |
					   checkedScopeNodes anySatisfy: [ :n |
							   n value = scopeNode value ] ];
				   onActivation: [ :scopeNode | self activateItem: scopeNode ];
				   onDeactivation: [ :scopeNode | self deactivateItem: scopeNode ];
				   yourself);
		  addColumn: (SpImageTableColumn new
				   beNotExpandable;
				   evaluated: [ :each |
						self iconNamed: each scopesIconName ];
				   yourself);
		  addColumn: self nodeDescriptionColumn;
		  yourself
]

{ #category : 'refreshing' }
ScopeNodesPresenter >> refresh [

	scopeNodesTree roots: (model allPackagesInEnvironment
			 collect: [ :package | ScopePackageNode on: package ]
			 thenSelect: [ :each | self node: each matches: nodeNameText text ]).
					
	
]

{ #category : 'refreshing' }
ScopeNodesPresenter >> refreshNodeCheckbox: aNode [

	| checkedClasses root package |
	aNode isPackageNode ifTrue: [
		(checkedScopeNodes includes: aNode)
			ifTrue: [
			aNode children do: [ :child | checkedScopeNodes add: child ] ]
			ifFalse: [
			aNode children do: [ :child | checkedScopeNodes remove: child ifAbsent: [  ] ] ].
		scopeNodesTree refresh.
		^ self ].

	checkedClasses := checkedScopeNodes
		                  select: [ :n | n isClassNode ]
		                  thenCollect: [ :n | n value ].
	root := (scopeNodesTree roots select: [ :r |
		         r children includes: aNode ]) anyOne.
	package := root package.
	root children size
	= (checkedClasses select: [ :c | c package = package ]) size
		ifFalse: [ checkedScopeNodes remove: root ifAbsent: [  ] ].

	scopeNodesTree refresh
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> removeNode: aNode [
	
	checkedScopeNodes remove: aNode.
	self refreshNodeCheckbox: aNode.
]

{ #category : 'initialization' }
ScopeNodesPresenter >> saveNewScope [
	
	| label newScope |
	
	label := self getScopeName.
	label ifNil: [ ^ self ].
	
	newScope := self newScopeFrom: self checkedItems.
	newScope label: label.
	
	model addScope: newScope.
	self announceScopeCreated: newScope
	
]

{ #category : 'initialization' }
ScopeNodesPresenter >> saveScope [

	self validate ifFalse: [
		self inform: 'You must check at least one item'.
		^ self ].

	self editing
		ifFalse: [ self saveNewScope ]
		ifTrue: [ self editScope: scope ].
	self close
		
	
	
]

{ #category : 'saving' }
ScopeNodesPresenter >> saveScopeAs [

	| label newScope |
	self validate ifFalse: [
		self inform: 'You must check at least one item'.
		^ self ].

	label := self getNameFromUser.
	(self validateNameBlock value: label)
		ifTrue: [ label := model nameWithIndex: label ]
		ifFalse: [^ self ].

	newScope := self newScopeFrom: self checkedItems.
	newScope label: label.
	
	model addScope: newScope.
	self announceScopeCreated: newScope.
	self close
	
]

{ #category : 'accessing' }
ScopeNodesPresenter >> scope: aRBEnvironment [

	| orphanClasses incompletePackages fullPackages |
	scope := aRBEnvironment.
	
	nodeNameText text: ''.
	orphanClasses := scope orphanClasses.
	incompletePackages := (orphanClasses collect: [ :class |
		                       class package ]) asSet.
	fullPackages := scope fullPackages.
	
	allScopeNodeTreeRoots doWithIndex: [ :packageNode :index |
		(fullPackages includes: packageNode value)
			ifTrue: [ "Check the package and all of its classes"
				checkedScopeNodes add: packageNode.
				packageNode children do: [ :classNode |
					checkedScopeNodes add: classNode ] ]
			ifFalse: [
				(incompletePackages includes: packageNode value) ifTrue: [ "This package contains orphan classes, check them, but do not check the package"
					scopeNodesTree selectItem: packageNode.
					packageNode children do: [ :classNode |
						(orphanClasses includes: classNode value) ifTrue: [
							checkedScopeNodes add: classNode ] ] ] ] ].
	scopeNodesTree expandSelectedItems.
	self refresh
]

{ #category : 'initialization' }
ScopeNodesPresenter >> uncheckAll [

	scopeNodesTree roots do: [ :root |
		root children do: [ :child |
			(checkedScopeNodes includes: child) ifTrue: [
				self deactivateItem: child ] ] ]
]

{ #category : 'validation' }
ScopeNodesPresenter >> validate [

	checkedScopeNodes ifEmpty: [ ^ false ].
	^ true
]
