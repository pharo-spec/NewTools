"
I display a tree with all the available packages and classes to create a scope
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
	#category : 'NewTools-Scopes-Browser-GUI',
	#package : 'NewTools-Scopes-Browser',
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

{ #category : 'instance creation' }
ScopeNodesPresenter class >> title [
	^ 'Scope Editor'
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> activateItem: scopeNode [

	self addNode: scopeNode.
	
	scopeNode children isEmptyOrNil ifTrue: [ ^ self ].
	
	scopeNode children do: [ :child | self addNode: child ].
	
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> addClassHierarchyForClass: aScopeNode [

	| class supers suprclass |
	self activateItem: aScopeNode.
	class := aScopeNode value.
	class = Object ifTrue: [ ^ self ].
	
	suprclass := class superclass.
	supers := class allSuperclasses.
	supers := supers select: [ :each | each value ~= Object and: each value ~= ProtoObject ].

	self allScopeNodeTreeRoots do: [ :root |
		root children do: [ :child |
			(supers includes: child value) ifTrue: [
				self activateItem: child ] ] ]
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> addNode: aNode [

	(checkedScopeNodes anySatisfy: [ :node | aNode value = node value ])
		ifFalse: [ checkedScopeNodes add: aNode ].
	self refreshCheckbox
]

{ #category : 'as yet unclassified' }
ScopeNodesPresenter >> allScopeNodeTreeRoots [

	^ allScopeNodeTreeRoots ifNil: [
		  allScopeNodeTreeRoots := model allPackagesInEnvironment
			                           reject: [ :package | package definedClasses isEmpty ]
			                           thenCollect: [ :package | ScopePackageNode on: package ] ]
]

{ #category : 'announcements' }
ScopeNodesPresenter >> announceScopeEdited [
	
	self announcer announce: (ScopeEditedAnnouncement new)
]

{ #category : 'private - presenters' }
ScopeNodesPresenter >> argumentsListMenu [
	^ self newMenu
		addGroup: [ :aGroup |
			aGroup
				addItem: [ :anItem |
					anItem
						name: 'Add class hierarchy';
						visibleIf: [ scopeNodesTree selectedItem isClassNode  ];
						action: [ self addClassHierarchyForClass: scopeNodesTree selectedItem ] ] ]
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> close [
	self window close
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> deactivateItem: scopeNode [

	self removeNode: scopeNode.
	scopeNode children isEmptyOrNil ifTrue: [ ^ self ].
	
	scopeNode children do: [ :child | self removeNode: child ].
	
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initialize [

	super initialize.
	checkedScopeNodes := Set new.
	self registerEvents
	
	
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
		                action: [ self saveScope ];
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

{ #category : 'announcements' }
ScopeNodesPresenter >> initializeScope [
	self assert: checkedScopeNodes isNotEmpty.
	scope := (model newScopeFrom: checkedScopeNodes)
]

{ #category : 'initialization' }
ScopeNodesPresenter >> initializeScopeNodesTree [
	^ scopeNodesTree
		  hideColumnHeaders;
		  addColumn: self nodesListColumn;
		  children: [ :each |
			  (each children select: [ :node |
					   (node name asLowercase beginsWith:
							    nodeNameText text asLowercase) or: [
							   node package name asLowercase beginsWith:
									   nodeNameText text asLowercase ] ]) asOrderedCollection
				  sorted ];
		  beMultipleSelection;
		  roots: self allScopeNodeTreeRoots asOrderedCollection sorted;
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection |
			  scopeNodesTree toggleSelectedItems ];
		  contextMenu: self argumentsListMenu
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

{ #category : 'private - presenters' }
ScopeNodesPresenter >> openScopeNameDialog [

	| nameDialog |
	nameDialog := (ScopeNamePresenter on: model)
		              newScope: scope;
		              yourself.
	nameDialog openDialog
		okAction: [ nameDialog submit ];
		cancelAction: [ nameDialog close ]
]

{ #category : 'refreshing' }
ScopeNodesPresenter >> refresh [

	scopeNodesTree roots: (model allPackagesInEnvironment
			 collect: [ :package | ScopePackageNode on: package ]
			 thenSelect: [ :each |
				 (each name asLowercase beginsWith: nodeNameText text asLowercase)
					 or: [
						 each definedClasses anySatisfy: [ :class |
							 class name asLowercase beginsWith:
								 nodeNameText text asLowercase ] ] ]).
					
	
]

{ #category : 'refreshing' }
ScopeNodesPresenter >> refreshCheckbox [

	scopeNodesTree roots do: [ :packageNode |
		(packageNode children allSatisfy: [ :classNode |
			 checkedScopeNodes anySatisfy: [ :checkedClassNode |
				 checkedClassNode = classNode ] ])
			ifTrue: [ checkedScopeNodes add: packageNode ]
			ifFalse: [ checkedScopeNodes remove: packageNode ifAbsent: [ ] ] ].
	
	scopeNodesTree refresh
]

{ #category : 'announcements' }
ScopeNodesPresenter >> registerEvents [

	self announcer
		when: ScopeCreatedAnnouncement
		do: [ :ann |
			self announcer unsubscribe: self.
			self close ]
		for: self
]

{ #category : 'private - actions' }
ScopeNodesPresenter >> removeNode: aNode [
	
	checkedScopeNodes removeAllSuchThat: [ :each |
		each value = aNode value ].
	self refreshCheckbox.
]

{ #category : 'initialization' }
ScopeNodesPresenter >> saveScope [

	scope
		ifNil: [
			self initializeScope.
			self openScopeNameDialog ]
		ifNotNil: [
			| editedScope |
			editedScope := model newScopeFrom: checkedScopeNodes.
			editedScope label: scope label.
			model removeScope: scope.
			model addScope: editedScope.
			self announceScopeEdited.
			self close ]
]

{ #category : 'accessing' }
ScopeNodesPresenter >> scope: aRBEnvironment [

	| packages |
	scope := aRBEnvironment.
	packages := scope packages.
	scopeNodesTree roots withIndexDo: [ :packageNode :index |
		(packages anySatisfy: [ :package | packageNode value = package ])
			ifTrue: [
				| classNodes classes |
				classNodes := packageNode children.
				classes := scope classes.
				"all packageNode children should be checked, including the packageNode"
				(classNodes allSatisfy: [ :classNode |
					 classes anySatisfy: [ :cls | cls name = classNode value name ] ])
					ifTrue: [
						classNodes do: [ :clsNode | checkedScopeNodes add: clsNode ].
						checkedScopeNodes add: packageNode ]
					ifFalse: [ "only some packageNode children should be checked, and as result, the packageNode is not selected"
						classNodes do: [ :classNode |
							(classes includes: classNode value) ifTrue: [
								checkedScopeNodes add: classNode ].
							scopeNodesTree expandPath: { index } ] ] ] ].

	self refreshCheckbox
]
