Class {
	#name : 'StFileBrowserAbstractPresenter',
	#superclass : 'StPresenter',
	#classTraits : 'TraitedClass',
	#instVars : [
		'bookmarksTreeTable',
		'model'
	],
	#classVars : [
		'Bookmarks',
		'LastVisitedDirectory'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFileBrowserAbstractPresenter class >> defaultDirectory [
	"Answer a <FileReference> with the default directory for opening the file browser and dialogs"

	^ StFileBrowserSettings defaultDirectory
]

{ #category : 'class initialization' }
StFileBrowserAbstractPresenter class >> initialize [

	self initializeBookmarks.
]

{ #category : 'class initialization' }
StFileBrowserAbstractPresenter class >> initializeBookmarks [

	Bookmarks := StFileBrowserBookmark defaultBookmarks
]

{ #category : 'accessing' }
StFileBrowserAbstractPresenter class >> lastVisitedDirectory [

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory
]

{ #category : 'instance creation' }
StFileBrowserAbstractPresenter class >> open [

	^ (self on: StFileSystemModel new) open
]

{ #category : 'adding' }
StFileBrowserAbstractPresenter >> addBookmark: aFileReference [ 

	self bookmarks add: (StFileBrowserBookmark 
		name: aFileReference basename 
		location: aFileReference 
		icon: (self iconNamed: #book)).
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks [

	Bookmarks 
		ifNil: [ self class initialize ].
	^ Bookmarks
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks: aCollectionOfFDGroupBookMark [

	Bookmarks := aCollectionOfFDGroupBookMark asOrderedCollection.
	bookmarksTreeTable roots: Bookmarks 
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarksTreeTableItems: aCollection [
	"Convenience method to set the receiver's bookmarks table items to aCollection"
	
	bookmarksTreeTable roots: aCollection
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> createDirectory [

	self model createDirectory.
	self updateFileSystemContents.
]

{ #category : 'accessing' }
StFileBrowserAbstractPresenter >> currentDirectory [ 
	"Answer a <FileReference> representing the current working directory"
	
	^ self model currentDirectory
]

{ #category : 'accessing' }
StFileBrowserAbstractPresenter >> currentDirectory: aFileReference [

	self model currentDirectory: aFileReference.
]

{ #category : 'defaults' }
StFileBrowserAbstractPresenter >> defaultDirectory [
	"See class side comment"

	^ self class defaultDirectory.
]

{ #category : 'accessing - history' }
StFileBrowserAbstractPresenter >> history [

	^ self model history
]

{ #category : 'accessing - history' }
StFileBrowserAbstractPresenter >> history: aConfigurableHistoryIterator [ 

	self model history: aConfigurableHistoryIterator.
]

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> initialize [

	super initialize.
	(StFileBrowserSettings showAlwaysDefaultBookmarks and: [ self bookmarks isEmpty ])
		ifTrue: [ self class initializeBookmarks ]
]

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> initializeBookmarksTreeTable [

	bookmarksTreeTable := self newTreeTable.
	bookmarksTreeTable
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn new
				 addColumn:
					 (SpImageTableColumn evaluated: [ :each | each icon ])
						 beNotExpandable;
				 addColumn:
					 (SpStringTableColumn evaluated: [ :groupBookMark | 
							  groupBookMark name ]);
				 yourself);
		roots: self bookmarks;
		children: #children;
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ];
		expandRoots
]

{ #category : 'accessing - history' }
StFileBrowserAbstractPresenter >> initializeHistoryIteratorWith: aDirectory [

	self history: (ConfigurableHistoryIterator
		undo: [ :folder | self history hasPrevious
			ifTrue: [ self updateWidgetWithFileReference: self history current ]
			ifFalse: [ self inform: 'Nothing to undo' ] ]
		redo: [ :folder | self updateWidgetWithFileReference: folder ]).
	self history register: aDirectory
]

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> initializePresenters [ 

	super initializePresenters.
	self initializeBookmarksTreeTable
]

{ #category : 'accessing - history' }
StFileBrowserAbstractPresenter >> lastVisitedDirectory [
	^ self class lastVisitedDirectory.
]

{ #category : 'accessing' }
StFileBrowserAbstractPresenter >> model [
	"Answer the receiver's <StFileSystemModel>"

	^ model
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> openOnLastDirectory [ 
	"Answer <true> if receiver should open in the last used directory"
	
	^ StFileBrowserSettings openOnLastDirectory
]

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> resetBookmarks [
	"Reset bookmarks to their defaults"

	self class initializeBookmarks
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> selectedBookMark [
	^ bookmarksTreeTable selection selectedItem
]

{ #category : 'accessing - model' }
StFileBrowserAbstractPresenter >> setModelBeforeInitialization: aStFBFileSystemModel [

	model := aStFBFileSystemModel
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> updateFileSystemContents [

	self owner updateFileSystemContents
]
