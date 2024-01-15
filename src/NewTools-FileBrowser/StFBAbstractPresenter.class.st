Class {
	#name : 'StFBAbstractPresenter',
	#superclass : 'StPresenter',
	#classTraits : '{} + TraitedClass',
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
StFBAbstractPresenter class >> defaultDirectory [

	^ StFBSettings defaultDirectory
]

{ #category : 'class initialization' }
StFBAbstractPresenter class >> initialize [

	Bookmarks := StFBBookmark defaultBookmarks
]

{ #category : 'accessing' }
StFBAbstractPresenter class >> lastVisitedDirectory [

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory
]

{ #category : 'instance creation' }
StFBAbstractPresenter class >> open [

	^ (self on: StFBFileSystemModel new) open
]

{ #category : 'adding' }
StFBAbstractPresenter >> addBookmark: aFileReference [ 

	self bookmarks add: (StFBBookmark 
		name: aFileReference basename 
		location: aFileReference 
		icon: nil).
]

{ #category : 'accessing - bookmarks' }
StFBAbstractPresenter >> bookmarks [

	Bookmarks 
		ifNil: [ self class initialize ].
	^ Bookmarks
]

{ #category : 'accessing - bookmarks' }
StFBAbstractPresenter >> bookmarks: aCollectionOfFDGroupBookMark [

	Bookmarks := aCollectionOfFDGroupBookMark asOrderedCollection.
	bookmarksTreeTable roots: Bookmarks 
]

{ #category : 'accessing - bookmarks' }
StFBAbstractPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : 'utilities' }
StFBAbstractPresenter >> createDirectory [

	self model createDirectory.
	self updateTableContent.
]

{ #category : 'accessing' }
StFBAbstractPresenter >> currentDirectory [ 
	"Answer a <FileReference> representing the current working directory"
	
	^ self model currentDirectory
]

{ #category : 'accessing' }
StFBAbstractPresenter >> currentDirectory: aFileReference [

	self model currentDirectory: aFileReference.
]

{ #category : 'accessing - history' }
StFBAbstractPresenter >> history [

	^ self model history
]

{ #category : 'accessing - history' }
StFBAbstractPresenter >> history: aConfigurableHistoryIterator [ 

	self model history: aConfigurableHistoryIterator.
]

{ #category : 'accessing - history' }
StFBAbstractPresenter >> initializeHistoryIteratorWith: aDirectory [

	self history: (ConfigurableHistoryIterator
		undo: [ :folder | self history hasPrevious
			ifTrue: [ self updateWidgetWithFileReference: self history current ]
			ifFalse: [ self inform: 'Nothing to undo' ] ]
		redo: [ :folder | self updateWidgetWithFileReference: folder ]).
	self history register: aDirectory
]

{ #category : 'accessing - history' }
StFBAbstractPresenter >> lastVisitedDirectory [
	^ self class lastVisitedDirectory.
]

{ #category : 'accessing' }
StFBAbstractPresenter >> model [

	^ model
]

{ #category : 'utilities' }
StFBAbstractPresenter >> openFolder: aFileReference [

	self owner openFolder: aFileReference
]

{ #category : 'initialization' }
StFBAbstractPresenter >> openOnLastDirectory [ 
	"Answer <true> if receiver should open in the last used directory"
	
	^ StFBSettings openOnLastDirectory
]

{ #category : 'accessing - bookmarks' }
StFBAbstractPresenter >> selectedBookMark [
	^ bookmarksTreeTable selection selectedItem
]

{ #category : 'accessing - model' }
StFBAbstractPresenter >> setModelBeforeInitialization: aStFBFileSystemModel [

	model := aStFBFileSystemModel
]

{ #category : 'utilities' }
StFBAbstractPresenter >> updateTableContent [

	self owner updateTableContent
]
