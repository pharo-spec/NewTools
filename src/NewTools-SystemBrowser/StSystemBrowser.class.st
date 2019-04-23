Class {
	#name : #StSystemBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'packagesTree',
		'classesList',
		'inspectionPanel',
		'codePanel',
		'navigationEnvironment',
		'model'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSystemBrowser class >> defaultSpec [

	^ SpecPanedLayout newVertical
		add: (SpecPanedLayout newHorizontal
			add: (SpecPanedLayout newHorizontal
				add: #packagesTree;
				add: #classesList;
				yourself);
			add: #inspectionPanel;
			yourself);
		add: #codePanel;
		yourself
]

{ #category : #opening }
StSystemBrowser class >> open [
	<script>

	^ self openOn: ClyNavigationEnvironment currentImage
]

{ #category : #opening }
StSystemBrowser class >> openOn: anEnvironment [

	^ (self on: anEnvironment) openWithSpec
]

{ #category : #accessing }
StSystemBrowser class >> preferredExtent [

	^ 900@700
]

{ #category : #initialization }
StSystemBrowser >> initializeWidgets [
	
	packagesTree := self newPackagesTree.
	classesList := self newClassesList.
	
	inspectionPanel := self newNotebook 
		addPage: self newInstaceSidePage;
		addPage: self newClassSidePage;
		addPage: self newVariablesPage;
		yourself.
	codePanel := self newLabel label: 'TODO'.
	
	packagesTree transmitTo: classesList transform: #classes.
]

{ #category : #initialization }
StSystemBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: self preferredExtent
]

{ #category : #'accessing model' }
StSystemBrowser >> model [ 

	^ model
]

{ #category : #initialization }
StSystemBrowser >> newClassSidePage [
	
	^ self newNotebookPage
		title: 'Class';
		presenterProvider: [ LabelPresenter new label: 'TODO' ];
		yourself
]

{ #category : #initialization }
StSystemBrowser >> newClassesList [

	^ self newTable
		hideColumnHeaders;
		addColumn: (CompositeTableColumn 
			with: (ImageTableColumn evaluated: #icon);
			with: (StringTableColumn evaluated: #name));
		yourself
]

{ #category : #initialization }
StSystemBrowser >> newInstaceSidePage [
	
	^ self newNotebookPage
		title: 'Instance';
		presenterProvider: [ LabelPresenter new label: 'TODO' ];
		yourself
]

{ #category : #initialization }
StSystemBrowser >> newPackagesTree [
	
	^ self newTreeTable
		hideColumnHeaders;
		addColumn: (CompositeTableColumn 
			with: (ImageTableColumn evaluated: #icon)
			with: (StringTableColumn evaluated: #name));
		roots: self model allPackages;
		children: #children;
		yourself
]

{ #category : #initialization }
StSystemBrowser >> newVariablesPage [
	
	^ self newNotebookPage
		title: 'Variables';
		presenterProvider: [ LabelPresenter new label: 'TODO' ];
		yourself
]

{ #category : #accessing }
StSystemBrowser >> preferredExtent [

	^ self class preferredExtent
]

{ #category : #'accessing model' }
StSystemBrowser >> setModelBeforeInitialization: aNavigationEnvironment [

	model := StSBEnvironmentModel newEnvironment: aNavigationEnvironment	
]
