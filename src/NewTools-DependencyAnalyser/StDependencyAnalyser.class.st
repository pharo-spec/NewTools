Class {
	#name : #StDependencyAnalyser,
	#superclass : #StPresenter,
	#instVars : [
		'toolbarPresenter',
		'treePresenter',
		'filterTextPresenter',
		'browserPresenter'
	],
	#category : #'NewTools-DependencyAnalyser'
}

{ #category : #initialization }
StDependencyAnalyser >> initializePresenters [
	<script: 'self new openWithSpec'>
	
	toolbarPresenter := self newToolbar
		addItem: (self newToolbarButton
			label: 'Find cycles';
			yourself);
		yourself.
			
	treePresenter := self newTree
		roots: self rootsForTest;
		children: [ :aNode | self retrieveChildren: aNode ];
		display: [ :aNode | aNode label ];
		icon: [ :aNode | aNode icon ];
		yourself.
	filterTextPresenter := self newTextInput.
	browserPresenter := self newMorph.
			
	self layout: (SpPanedLayout newLeftToRight 
		position: 40 percent;
		add: (SpBoxLayout newTopToBottom
			add: toolbarPresenter expand: false;
			add: treePresenter;
			add: filterTextPresenter expand: false;
			yourself);
		add: browserPresenter;
		yourself)
]

{ #category : #initialization }
StDependencyAnalyser >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Dependency Analyser';
		initialExtent: 1200@800
]

{ #category : #initialization }
StDependencyAnalyser >> retrieveChildren: aNode [

 	^ aNode children 
		collect: [ :each | 
			DAPackageUnderAnalysisNode new
				content: each;
				cycle: false;
				"treeModelParent: self;
				browser: self browser;"
				yourself ]
]

{ #category : #initialization }
StDependencyAnalyser >> rootsForTest [

	^ (DAPackageAnalyzerTreeModel onPackagesNamed: #('Spec2-Core')) tree roots
]
