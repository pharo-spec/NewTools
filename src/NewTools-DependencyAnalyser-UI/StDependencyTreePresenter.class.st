"
A PDPackageAnalyzerTreeModel shows all dependent packages from a set of packages. Also you can see all type of the dependency, and browse them.
"
Class {
	#name : 'StDependencyTreePresenter',
	#superclass : 'StPackageTreePresenter',
	#instVars : [
		'systemCycles',
		'packageLabel',
		'buttonBrowseCycles',
		'buttonDefault',
		'textPackageField',
		'filter',
		'buttonAddPackage',
		'buttonGenerateGraphViz',
		'buttonRemovePackage',
		'buttonReverseAnalysis',
		'buttonSave',
		'buttonMakeDiff',
		'relationGraph',
		'actionBar'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Core',
	#package : 'NewTools-DependencyAnalyser-UI',
	#tag : 'Core'
}

{ #category : 'layout' }
StDependencyTreePresenter class >> defaultLayout [
	<spec: #default>
	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
					add: #textPackageField expand: true;
					add: #buttonDefault expand: false;
					yourself)
			expand: false;
		add: #packageLabel expand: false;
		add: #tree;
		add: #actionBar expand: false;
		yourself
]

{ #category : 'examples' }
StDependencyTreePresenter class >> onPackagesMatch: match [

	^ self onPackagesNamed: (self packageOrganizer packages
			   select: [ :package | match match: package packageName asString ]
			   thenCollect: [ :package | package packageName ])
]

{ #category : 'instance creation' }
StDependencyTreePresenter class >> onPackagesNamed: aCollection [
	self flag: #IncreaseTechnicalDebt.
		"The flow is BAD AND WRONG! 
	We should not explicit use StPharoApplication current this is a bad practice. Now I have no idea how to do it otherwise. So let us propagate bad practices.
	You like debt: here it is"
	
	^ (self newApplication: StPharoApplication current) 
		initializeWith: aCollection;
		yourself
]

{ #category : 'specs' }
StDependencyTreePresenter class >> title [

	^ 'Dependencies analysis'
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnAddPackage [
	buttonAddPackage action: [ (StAddPackagePresenter
					new
					dependenciesPresenter: self)
					open ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnBrowseCycles [
	buttonBrowseCycles action: [ self actionOnFindCycles ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnButtons [

	self
		actionOnBrowseCycles;
		actionWhenTextFieldChanged;
		actionOnDefaultSettings;
		actionOnRemovePackage;
		actionOnAddPackage;
		actionOnReverseAnalysis;
		actionOnSave
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnDefaultSettings [
	buttonDefault
		action: [
			self resetDefaultSettings.
			self buildRoots ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnFindCycles [

	| selectedPackages selectedItems |
	selectedItems := self selectedItemsFromTree.
	(self arePackageNodes: selectedItems) ifFalse: [ ^ self ].

	self notify: 'This could take a while, confirm?'.
	selectedPackages := self pdPackagesFrom: selectedItems.
	systemCycles ifNil: [ systemCycles := StCycleDetectionPresenter system ].
	systemCycles
		updateWithFilter: selectedPackages;
		open
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnRemovePackage [
	| packagesToRemove |
	buttonRemovePackage
		action: [
			self selectedItemsFromTree
				ifNotEmpty: [
					packagesToRemove := self selectedItemsFromTree.
					packagesToRemove do: [ :item | self relationGraph removePackage: item content packageName ].
					self buildRoots ] ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnReverseAnalysis [

	buttonReverseAnalysis action: [
		(StPackageDependenciesPresenter on:
			 (StReverseTreePresenter onRelationGraph: self relationGraph)) open ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionOnSave [
	buttonSave
		action: [ self saveCurrentRelationGraph ]
]

{ #category : 'protocol' }
StDependencyTreePresenter >> actionWhenTextFieldChanged [
	textPackageField
		whenTextChangedDo: [ textPackageField text
				ifEmpty: [ self resetFilter ]
				ifNotEmpty: [ self filter: textPackageField text ].
			self buildRoots ]
]

{ #category : 'actions' }
StDependencyTreePresenter >> buildRoots [
	| matching roots |
	roots := self filter
		ifNotNil: [ :f |
			matching := '*' , f , '*'.
			self nodesFor: (relationGraph seenPackagesWithFilter: matching) ]
		ifNil: [ self nodesFor: relationGraph seenPackages ].
	self tree roots: roots.
	self updatePackageLabel
]

{ #category : 'initialization' }
StDependencyTreePresenter >> connectPresenters [
	
	super connectPresenters.
	
	self actionOnButtons.
	tree whenSelectedItemChangedDo: [ :item |
		item
			ifNil: [ buttonBrowseCycles enabled: false ]
			ifNotNil: [
				buttonBrowseCycles enabled: true.
				self tree selectedItem selectInBrowser ] ]
]

{ #category : 'saving' }
StDependencyTreePresenter >> createDirectoryForSaving [
	| dir |
	dir := FileSystem workingDirectory / self defaultDirectory.
	dir ensureCreateDirectory
]

{ #category : 'saving' }
StDependencyTreePresenter >> defaultDirectory [
	^ 'saving'
]

{ #category : 'saving' }
StDependencyTreePresenter >> defaultName [
	^ self defaultDirectory, '/relationGraph.FL'
]

{ #category : 'protocol' }
StDependencyTreePresenter >> extent [
	^ 700@500
]

{ #category : 'accessing' }
StDependencyTreePresenter >> filter [
	^ filter
]

{ #category : 'accessing' }
StDependencyTreePresenter >> filter: aString [
	filter := aString
]

{ #category : 'initialization' }
StDependencyTreePresenter >> initializeButtons [

	buttonRefresh
		icon: (self iconNamed: #refresh);
		label: ''.
	buttonBrowseCycles := self newButton
		help: 'Find all the cycles where the package is in the system';
		icon: (self iconNamed: #objects).
	buttonDefault := self newButton
		help: 'Restore default settings';
		label: 'Reset'.
	buttonAddPackage := self newButton
		help: 'Add packages to the current analysis';
		icon: (self iconNamed: #add).
	buttonRemovePackage := self newButton
		help: 'Remove packages to the current analysis';
		icon: (self iconNamed: #remove).
	buttonGenerateGraphViz := self newButton
		help: 'Open the graph in world';
		label: 'Open the graph'.
	buttonReverseAnalysis := self newButton
		help: 'Reverse the analysis : set the dependent packages as root packages';
		icon: (self iconNamed: #refresh).
	buttonSave := self newButton
		help: 'Serialize the current object relation graph dependencies';
		label: 'Save current analysis'.
	buttonMakeDiff := self newButton
		label: 'Make diff'.
	
	actionBar := self newActionBar
		add: buttonAddPackage;
		add: buttonRemovePackage;
		addLast: buttonRefresh;
		addLast: buttonReverseAnalysis;
		addLast: buttonBrowseCycles;
		yourself.
]

{ #category : 'initialization' }
StDependencyTreePresenter >> initializePresenters [

	super initializePresenters.
	packageLabel := self newLabel label: 'Analysis of packages'.
	textPackageField := self newTextInput
		                    placeholder: 'Enter a package name';
		                    entryCompletion: self packagesEntryCompletion.
	self initializeButtons.

	tree actionsWith: [ :group |
			group
				addActionWith: [ :action |
						action
							name: 'Browse scoped dependencies';
							actionEnabled: [
									(self areSubclassToPackageDependencyNodes: self selectedItemsFromTree)
										ifTrue: [ self selectedPackageNames isNotEmpty ]
										ifFalse: [ false ] ];
							action: [
									(StPackageDependenciesPresenter onPackagesNamed: self selectedPackageNames)
										application: self application;
										open ] ];
				addActionWith: [ :action |
						action
							name: 'Find cycles among packages';
							action: [
									(StCycleDetectionPresenter onPackagesNamed: self selectedPackageNames)
										application: self application;
										open ] ];
				addActionWith: [ :action |
						action
							name: 'Browse dependencies from class';
							actionEnabled: [ self areClassToDependencyNodes: self selectedItemsFromTree ];
							action: [ self openTreeFor: self selectedNames ] ] ]
]

{ #category : 'accessing' }
StDependencyTreePresenter >> initializeWith: packageNames [

	self relationGraph: (StPackageRelationGraph onPackages: (packageNames collect: [ :packageName | StPackage onPackageNamed: packageName ]))
]

{ #category : 'private' }
StDependencyTreePresenter >> nodesFor: anItemList [
	^ anItemList sorted collect:
		[ :each |
		StPackageUnderAnalysisNode new
			content: each;
			cycle: false;
			treeModelParent: self;
			browser: self browser;
			yourself ]
]

{ #category : 'accessing' }
StDependencyTreePresenter >> packagesEntryCompletion [

	| applicants |
	applicants := self packageOrganizer packages collect: [ :package | package name asString ].

	^ EntryCompletion new
		  dataSourceBlock: [ :currText | applicants ];
		  filterBlock: [ :currApplicant :currText | currText size > 3 and: [ currApplicant asUppercase includesSubstring: currText asString asUppercase ] ]
]

{ #category : 'accessing' }
StDependencyTreePresenter >> pdPackagesFrom: selectedItems [

	^ selectedItems collect: [ :item | StPackage onPackageNamed: item content packageName asString ]
]

{ #category : 'actions' }
StDependencyTreePresenter >> refresh [
	self relationGraph refreshGraph.
	self buildRoots
]

{ #category : 'accessing' }
StDependencyTreePresenter >> relationGraph [
	^ relationGraph
]

{ #category : 'accessing' }
StDependencyTreePresenter >> relationGraph: anObject [
	| warnings alertMessage |
	warnings := Set new.
	relationGraph := anObject.

	[ self relationGraph build ]
		on: StPotentialOutDatedDependencyWarning
		do: [ :ex | warnings add: ex. ex resume ].
	self buildRoots.
	alertMessage := 'Some dependencies declared in ' ,
		self relationGraph packagesName first,
		' Manifest as manuallyResolvedDependencies not detected as a dependency! Please check :' , String cr.
	warnings 	ifNotEmpty: [
		self application newInform
			label: alertMessage , (String cr join: (warnings collect: #dependency ));
			title: 'Potential outdated dependencies';
			openModal ]
]

{ #category : 'actions' }
StDependencyTreePresenter >> resetDefaultSettings [
	self resetFilter.
	textPackageField text: ''
]

{ #category : 'actions' }
StDependencyTreePresenter >> resetFilter [
	^ self filter: nil
]

{ #category : 'saving' }
StDependencyTreePresenter >> saveCurrentRelationGraph [
	self createDirectoryForSaving.
	^  FLSerializer new
			filePath: self defaultName;
			object: relationGraph;
			serialize
]

{ #category : 'accessing' }
StDependencyTreePresenter >> seenPackagesName [
	^ self relationGraph seenPackagesName
]

{ #category : 'initialization' }
StDependencyTreePresenter >> selectedNames [

	^ self selectedItemsFromTree collect: [ :package | package content theClass ]
]

{ #category : 'initialization' }
StDependencyTreePresenter >> selectedPackageNames [
		
	^ self selectedItemsFromTree collect: [ :packageNode | packageNode content packageName ]

]

{ #category : 'accessing' }
StDependencyTreePresenter >> sizeOfRoots [
	^ self treeRoots size
]

{ #category : 'accessing' }
StDependencyTreePresenter >> treeRoots [
	^ self tree roots
]

{ #category : 'accessing' }
StDependencyTreePresenter >> updatePackageLabel [
	packageLabel label: 'Analysis of ' , self sizeOfRoots asString , ' package(s)'
]

{ #category : 'accessing' }
StDependencyTreePresenter >> windowTitle [ 

	^ 'Dependencies analysis'
]
