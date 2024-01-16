"
General file system presenter, which replaces the older FileList tool.

"
Class {
	#name : 'StFileSystemPresenter',
	#superclass : 'StFileBrowserAbstractPresenter',
	#instVars : [
		'treeNavigationSystem',
		'fileNavigationSystem'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'defaults' }
StFileSystemPresenter class >> lastVisitedDirectory [

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory 
]

{ #category : 'initialization' }
StFileSystemPresenter >> connectPresenters [ 

	treeNavigationSystem
		transmitDo: [ : selection | selection ifNotNil: [ self updateWidgetWithFileReference: selection fileReference ] ].

	fileNavigationSystem := self instantiate: StFileNavigationSystemPresenter on: self model.
	fileNavigationSystem 
		columns: { 
			StFileBrowserModificationDateColumn .
			StFileBrowserSizeColumn .
			StFileBrowserRightsColumn }
]

{ #category : 'layout' }
StFileSystemPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
			positionOfSlider: 0.2;
			add: treeNavigationSystem;
			add: fileNavigationSystem;
			yourself
]

{ #category : 'accessing' }
StFileSystemPresenter >> expandPath: aFileReference [ 
	"Expand the directory's navigation tree to aFileReference"

	treeNavigationSystem expandPath: aFileReference
]

{ #category : 'initialization' }
StFileSystemPresenter >> initialExtentForWindow [

	^ (900 @ 600) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
StFileSystemPresenter >> initializePresenters [

	treeNavigationSystem := self instantiate: StDirectoryTreePresenter on: self model.
	fileNavigationSystem := self instantiate: StFileNavigationSystemPresenter on: self model.
	fileNavigationSystem 
		columns: { 
			StFileBrowserModificationDateColumn .
			StFileBrowserSizeColumn .
			StFileBrowserRightsColumn }.
	treeNavigationSystem expandPath: fileNavigationSystem currentDirectory.

]

{ #category : 'initialization' }
StFileSystemPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	self setTitleTo: aSpWindowPresenter.
	self setWindowIconTo: aSpWindowPresenter.
	self setInitialExtentTo: aSpWindowPresenter
]

{ #category : 'utilities' }
StFileSystemPresenter >> openFolder: aFileReference [

	fileNavigationSystem updateWidgetWithFileReference: aFileReference.
	model openFolder: aFileReference.
	self expandPath: aFileReference.

]

{ #category : 'initialization' }
StFileSystemPresenter >> setInitialExtentTo: aSpWindowPresenter [
	
	aSpWindowPresenter initialExtent: self initialExtentForWindow
]

{ #category : 'initialization' }
StFileSystemPresenter >> setTitleTo: aSpWindowPresenter [

	aSpWindowPresenter title: 'File List'

]

{ #category : 'initialization' }
StFileSystemPresenter >> setWindowIconTo: aSpWindowPresenter [
	
	aSpWindowPresenter	windowIcon: (self iconNamed: #open).

]

{ #category : 'utilities' }
StFileSystemPresenter >> updateFileSystemContents [

	fileNavigationSystem updateFileSystemContents.


]

{ #category : 'utilities' }
StFileSystemPresenter >> updateWidgetWithFileReference: aFileReference [ 

	aFileReference exists
		ifTrue: [ fileNavigationSystem updateWidgetWithFileReference: aFileReference ]
]
