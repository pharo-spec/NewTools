"
I'm an abstract presenter.
I have the common UI definition of the dependency analyzer (left side panel, without the browser):
- main dependency analyzer window
- reverse dependency anlaysis
- and cycle detection
"
Class {
	#name : 'StPackageTreePresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'tree',
		'buttonRefresh',
		'browser'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Core',
	#package : 'NewTools-DependencyAnalyser-UI',
	#tag : 'Core'
}

{ #category : 'testing' }
StPackageTreePresenter class >> isAbstract [

	^self == StPackageTreePresenter
]

{ #category : 'testing' }
StPackageTreePresenter >> areClassToDependencyNodes: aCollectionOfItem [
	^ aCollectionOfItem allSatisfy: [ :node |  node isClassToDependencyNode ]
]

{ #category : 'testing' }
StPackageTreePresenter >> areMethodNodes: aCollectionOfItem [

	^ aCollectionOfItem allSatisfy: [ :node |  node isMethodImplementationNode ]
]

{ #category : 'testing' }
StPackageTreePresenter >> arePackageNodes: aCollectionOfItem [

	^ aCollectionOfItem allSatisfy: [ :node |  node isPackageNode ]
]

{ #category : 'testing' }
StPackageTreePresenter >> areSubclassToPackageDependencyNodes: aCollectionOfItem [

	^ aCollectionOfItem allSatisfy: [ :node | node content class inheritsFrom: StPackageDependency ]
]

{ #category : 'initialization' }
StPackageTreePresenter >> browseReference [
	self selectedItemFromTree isReferenceNode ifTrue: [
			self selectedItemFromTree browseReference
		 ]
]

{ #category : 'accessing' }
StPackageTreePresenter >> browser [
	^ browser
]

{ #category : 'private' }
StPackageTreePresenter >> buildRoots [
	self subclassResponsibility
]

{ #category : 'accessing' }
StPackageTreePresenter >> buttonRefresh [
	^ buttonRefresh
]

{ #category : 'actions' }
StPackageTreePresenter >> close [
	browser windowIsClosing
]

{ #category : 'initialization' }
StPackageTreePresenter >> connectPresenters [

	buttonRefresh action: [ self refresh ]
]

{ #category : 'protocol' }
StPackageTreePresenter >> defaultFormat [
	^ #png
]

{ #category : 'initialization' }
StPackageTreePresenter >> initializePresenters [

	tree := self newTree	
		beMultipleSelection;
		addShortcutWith: [ :action | action 
			shortcutKey: $b actionModifier;
			action: [ self selectedItemFromTree spawnNewBrowser ] ];
		children: [ :node | node buildChildren ];
		display: [ :node | node label ];
		displayIcon: [ :node | node icon ];
		expandRoots; "<= We want to open the browser with the dependencies displayed to the user"
		yourself.

	buttonRefresh := self newButton
		icon: (self iconNamed: #refresh);
		label: 'Refresh';
		help: 'Refresh the list of analyzed packages';
		yourself.

	browser := (self application toolNamed: #browser) onDefaultEnvironment
]

{ #category : 'actions' }
StPackageTreePresenter >> openTreeFor: namesOfSelected [

	| treeToOpen relationGraph window |
	treeToOpen := self newTree.
	relationGraph := self tree owner relationGraph.
	window := treeToOpen
		          roots: (namesOfSelected collect: [ :name |
					           StClassToDependencyNode new
						           content: name;
						           package: (relationGraph packageForClass: name) ]);
		          children: [ :node | node buildChildren ];
		          display: [ :node | node label ];
		          displayIcon: [ :node | node icon ];
		          asWindow.
	window
		title: 'Class dependencies';
		initialExtent: 700 @ 500;
		open
]

{ #category : 'actions' }
StPackageTreePresenter >> refresh [
	self subclassResponsibility
]

{ #category : 'actions' }
StPackageTreePresenter >> selectedItemFromTree [
	^ self tree selectedItem
]

{ #category : 'accessing' }
StPackageTreePresenter >> selectedItemsFromTree [
	^ self tree selectedItems
]

{ #category : 'accessing' }
StPackageTreePresenter >> tree [
	^ tree
]
