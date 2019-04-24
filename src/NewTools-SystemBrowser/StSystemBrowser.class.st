Class {
	#name : #StSystemBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'model',
		'inspectionPanel',
		'codePanel',
		'packagesPanel',
		'classesPanel',
		'instanceSidePanel',
		'classSidePanel'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSystemBrowser class >> defaultSpec [

	^ SpecPanedLayout newVertical
		add: (SpecPanedLayout newHorizontal
			add: (SpecPanedLayout newHorizontal
				add: #packagesPanel;
				add: #classesPanel;
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

	^ 900@650
]

{ #category : #initialization }
StSystemBrowser >> initializeWidgets [
	
	packagesPanel := self instantiate: StSBPackagesPanel on: self model.
	classesPanel := self instantiate: StSBClassesPanel on: self model.
	
	instanceSidePanel := self instantiate: StSBProtocolInspectionPanel on: self model.
	classSidePanel := self instantiate: StSBProtocolInspectionPanel on: self model.
	inspectionPanel := self newNotebook 
		addPage: (self newPage: 'Instance' provider: instanceSidePanel);
		addPage: (self newPage: 'Class' provider: classSidePanel); 
		addPage: (self newPage: 'Variables' provider: (LabelPresenter new label: 'TODO'));
		yourself.
		
	codePanel := self newLabel label: 'TODO'.
	
	packagesPanel transmitTo: classesPanel transform: #classes.
	classesPanel transmitTo: instanceSidePanel transform: #instanceProtocols.
	classesPanel transmitTo: classSidePanel transform: #classProtocols.	
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
StSystemBrowser >> newPage: aString provider: aBlock [
	
	^ self newNotebookPage
		title: aString;
		presenterProvider: aBlock;
		yourself
]

{ #category : #'accessing model' }
StSystemBrowser >> setModelBeforeInitialization: aNavigationEnvironment [

	model := StSBEnvironmentModel newEnvironment: aNavigationEnvironment	
]
