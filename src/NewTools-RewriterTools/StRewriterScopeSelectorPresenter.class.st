"
I am a presenter that allows to select a list of methods.
If you only click on one package, I will return all the methods of all the classes for that package. If you select one class, I will return all the methods of that class. If you select one method, I will only return that method.
I support multiselection for packages, classes and methods.

I can be initialized with a collection of packages `MethodsSelectorPresenter class>>#withPackages:`. If you do not set a collection of packages and only use `MethodsSelectorPresenter new` I will initialize with all Pharo packages by default.

To obtain the selected methods: `MethodsSelectorPresenter>>#selectedMethods`
"
Class {
	#name : 'StRewriterScopeSelectorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'methodsSelection',
		'classesListWithFilterPresenter',
		'packagesListWithFilterPresenter',
		'methodsListWithFilterPresenter'
	],
	#category : 'NewTools-RewriterTools-Transformer',
	#package : 'NewTools-RewriterTools',
	#tag : 'Transformer'
}

{ #category : 'accessing' }
StRewriterScopeSelectorPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : 'accessing' }
StRewriterScopeSelectorPresenter class >> icon [
	^ self iconNamed: self iconName
]

{ #category : 'accessing' }
StRewriterScopeSelectorPresenter class >> iconName [
	^ #objects
]

{ #category : 'specs' }
StRewriterScopeSelectorPresenter class >> title [

	^ 'Select the classes'
]

{ #category : 'accessing' }
StRewriterScopeSelectorPresenter class >> windowExtent [

	^ 530 @ 330
]

{ #category : 'instance creation' }
StRewriterScopeSelectorPresenter class >> withPackages: aPackagesCollection [

	^ self new initializeWithPackages: aPackagesCollection
]

{ #category : 'api' }
StRewriterScopeSelectorPresenter >> allowMethodSelection [

	methodsSelection := true
]

{ #category : 'actions' }
StRewriterScopeSelectorPresenter >> classesChanged [

	self updateSelectionForMethodsPresenter
]

{ #category : 'layout' }
StRewriterScopeSelectorPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: packagesListWithFilterPresenter;
		  add: classesListWithFilterPresenter;
		  add: methodsListWithFilterPresenter;
		  spacing: 5;
		  yourself
]

{ #category : 'api' }
StRewriterScopeSelectorPresenter >> doNotAllowMethodSelection [

	methodsSelection := false
]

{ #category : 'initialization' }
StRewriterScopeSelectorPresenter >> initializeClassesList [

	classesListWithFilterPresenter := self newFilteringList.
	classesListWithFilterPresenter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem iconNamed: elem systemIconName ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ :selection | self classesChanged ];
		beMultipleSelection
]

{ #category : 'initialization' }
StRewriterScopeSelectorPresenter >> initializeMethodsList [

	methodsListWithFilterPresenter := self newFilteringList.
	methodsListWithFilterPresenter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item selector ];
		sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : 'initialization' }
StRewriterScopeSelectorPresenter >> initializePackagesList [

	packagesListWithFilterPresenter := self newFilteringList.
	packagesListWithFilterPresenter items: RBBrowserEnvironment new packages.
	packagesListWithFilterPresenter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ self packagesChanged ];
		beMultipleSelection
]

{ #category : 'initialization' }
StRewriterScopeSelectorPresenter >> initializePresenters [

	self initializePackagesList.
	self initializeClassesList.
	self initializeMethodsList.

	self doNotAllowMethodSelection
]

{ #category : 'initialization' }
StRewriterScopeSelectorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		extent: self class windowExtent
]

{ #category : 'api' }
StRewriterScopeSelectorPresenter >> initializeWithPackages: aPackagesCollection [

	packagesListWithFilterPresenter items: aPackagesCollection
]

{ #category : 'showing' }
StRewriterScopeSelectorPresenter >> openDialog [

	| window |
	window := super openDialog.
	window resize: self class windowExtent.
	^ window
]

{ #category : 'actions' }
StRewriterScopeSelectorPresenter >> packagesChanged [

	self updateSelectionForClassesPresenter.
	self updateSelectionForMethodsPresenter
]

{ #category : 'api - accessing' }
StRewriterScopeSelectorPresenter >> selectedClasses [

	^ classesListWithFilterPresenter listPresenter selectedItems
]

{ #category : 'api - accessing' }
StRewriterScopeSelectorPresenter >> selectedMethods [

	^ methodsListWithFilterPresenter listPresenter selectedItems
		  ifEmpty: [ methodsListWithFilterPresenter items ]
		  ifNotEmpty: [ methodsListWithFilterPresenter listPresenter selectedItems ]
]

{ #category : 'actions' }
StRewriterScopeSelectorPresenter >> updateSelectionForClassesPresenter [

	| selectedClasses |
	selectedClasses := packagesListWithFilterPresenter listPresenter selectedItems
		flatCollect: [ :each | each definedClasses ] as: Set.

	classesListWithFilterPresenter items: selectedClasses asOrderedCollection.
	classesListWithFilterPresenter listPresenter selectItems: selectedClasses asOrderedCollection
]

{ #category : 'actions' }
StRewriterScopeSelectorPresenter >> updateSelectionForMethodsPresenter [

	| methodsInTheSelectedClasses |
	methodsInTheSelectedClasses := classesListWithFilterPresenter listPresenter
		selectedItems flatCollect: [ :each | each methods] as: Set.
	methodsListWithFilterPresenter items: methodsInTheSelectedClasses asOrderedCollection.

	methodsSelection
		ifTrue: [ methodsListWithFilterPresenter listPresenter selectItems: methodsInTheSelectedClasses asOrderedCollection ]
		ifFalse: [ methodsListWithFilterPresenter listPresenter resetListSelection ]
]
