"
General file system presenter, which replaces the older FileList tool.

"
Class {
	#name : 'StFBFileSystemPresenter',
	#superclass : 'StFBAbstractPresenter',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'treeNavigationSystem',
		'fileNavigationSystem'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'defaults' }
StFBFileSystemPresenter class >> lastVisitedDirectory [

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory 
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> connectPresenters [ 

	treeNavigationSystem
		transmitDo: [ : selection | selection ifNotNil: [ self updateWidgetWithFileReference: selection fileReference ] ].

	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter on: self model.
	fileNavigationSystem 
		columns: { 
			StFBModificationDateColumn .
			StFBSizeColumn .
			StFBRightsColumn }
]

{ #category : 'layout' }
StFBFileSystemPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
			positionOfSlider: 0.2;
			add: treeNavigationSystem;
			add: fileNavigationSystem;
			yourself
]

{ #category : 'accessing' }
StFBFileSystemPresenter >> expandPath: aFileReference [ 
	"Expand the directory's navigation tree to aFileReference"

	treeNavigationSystem expandPath: aFileReference
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> initialExtentForWindow [

	^ (900 @ 600) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> initializePresenters [

	treeNavigationSystem := self instantiate: StFBDirectoryTreePresenter on: self model.
	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter on: self model.
	fileNavigationSystem 
		columns: { 
			StFBModificationDateColumn .
			StFBSizeColumn .
			StFBRightsColumn }.
	treeNavigationSystem expandPath: fileNavigationSystem currentDirectory.

]

{ #category : 'initialization' }
StFBFileSystemPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	self setTitleTo: aSpWindowPresenter.
	self setWindowIconTo: aSpWindowPresenter.
	self setInitialExtentTo: aSpWindowPresenter
]

{ #category : 'utilities' }
StFBFileSystemPresenter >> openFolder: aFileReference [

	fileNavigationSystem updateWidgetWithFileReference: aFileReference.
	model openFolder: aFileReference.
	self expandPath: aFileReference

]

{ #category : 'initialization' }
StFBFileSystemPresenter >> setInitialExtentTo: aSpWindowPresenter [
	
	aSpWindowPresenter initialExtent: self initialExtentForWindow
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> setTitleTo: aSpWindowPresenter [

	aSpWindowPresenter title: 'File List'

]

{ #category : 'initialization' }
StFBFileSystemPresenter >> setWindowIconTo: aSpWindowPresenter [
	
	aSpWindowPresenter	windowIcon: (self iconNamed: #open).

]

{ #category : 'utilities' }
StFBFileSystemPresenter >> updateFileSystemContents [

	fileNavigationSystem updateFileSystemContents.


]

{ #category : 'utilities' }
StFBFileSystemPresenter >> updateWidgetWithFileReference: aFileReference [ 

	aFileReference exists
		ifTrue: [ fileNavigationSystem updateWidgetWithFileReference: aFileReference ]
]
