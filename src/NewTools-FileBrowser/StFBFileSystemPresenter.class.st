"
General file system presenter, which replaces the older FileList tool.

"
Class {
	#name : 'StFBFileSystemPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'treeNavigationSystem',
		'fileNavigationSystem'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StFBFileSystemPresenter class >> open [
	<example>

	self new open.
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> announcer [

	^ self application announcer
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> connectPresenters [ 

	treeNavigationSystem
		transmitDo: [ : sel | fileNavigationSystem openFolder: sel fileReference ].

	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter.
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

{ #category : 'initialization' }
StFBFileSystemPresenter >> initialExtentForWindow [

	^ (900 @ 600) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> initializePresenters [

	treeNavigationSystem := self instantiate: StFBDirectoryTreePresenter.
	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter.
	fileNavigationSystem 
		columns: { 
			StFBModificationDateColumn .
			StFBSizeColumn .
			StFBRightsColumn }.
	treeNavigationSystem expandPath: fileNavigationSystem currentDirectory.
	self registerEvents.
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	self setTitleTo: aSpWindowPresenter.
	self setWindowIconTo: aSpWindowPresenter.
	self setInitialExtentTo: aSpWindowPresenter
]

{ #category : 'initialization' }
StFBFileSystemPresenter >> registerEvents [

	self announcer subscriptions reset.

	self announcer weak
		when: StFBCurrentDirectoryChanged 
		send: #expandPath: 
		to: treeNavigationSystem.
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
