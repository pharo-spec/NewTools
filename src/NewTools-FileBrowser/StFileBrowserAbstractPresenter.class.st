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

{ #category : 'instance creation' }
StFileBrowserAbstractPresenter class >> new [

	^ self on: StFileSystemModel new
]

{ #category : 'instance creation' }
StFileBrowserAbstractPresenter class >> open [

	^ self new open
]

{ #category : 'adding' }
StFileBrowserAbstractPresenter >> addBookmark: aFileReference [ 

	self model addBookmark: aFileReference.
	bookmarksTreeTable 
		roots: self bookmarks;
		expandRoots;
		refresh.

]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks [

	^ self model bookmarks 
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks: aCollectionOfFDGroupBookMark [

	self model bookmarks: aCollectionOfFDGroupBookMark.
	bookmarksTreeTable roots: Bookmarks 
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> createDirectory [

	self model createDirectory.
	self updateFileSystemPresenters.
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

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> defaultColumns [

	^ { 
		StFileBrowserModificationDateColumn .
		StFileBrowserSizeColumn .
		StFileBrowserRightsColumn 
		}
]

{ #category : 'defaults' }
StFileBrowserAbstractPresenter >> defaultDirectory [
	"See class side comment"

	^ self model defaultDirectory.
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
	"Answer the <FileReference> of the last visited directory"

	^ self model lastVisitedDirectory
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

	self model resetBookmarks
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> selectedBookMark [
	^ bookmarksTreeTable selection selectedItem
]

{ #category : 'accessing - model' }
StFileBrowserAbstractPresenter >> setModelBeforeInitialization: aStFileSystemModel [

	model := aStFileSystemModel
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> updateFileSystemPresenters [

	self owner updateFileSystemPresenters
]
