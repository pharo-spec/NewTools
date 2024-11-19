"
It provides the following file system services to UI:

- History
- Default directory (global variable).
- Last visited directory (global variable).
- Directory opening and creation.
- Bookmarks
"
Class {
	#name : 'StFileSystemModel',
	#superclass : 'StPresenter',
	#instVars : [
		'currentDirectory',
		'history'
	],
	#classVars : [
		'Bookmarks',
		'LastVisitedDirectory'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'defaults' }
StFileSystemModel class >> defaultDirectory [
	"Answer a <FileReference> with the default directory for opening the file browser and dialogs"

	^ StFileBrowserSettings defaultDirectory.
]

{ #category : 'initialization' }
StFileSystemModel class >> initializeBookmarks [
	"Set the initial <Collection> of receiver's bookmarks"

	<script>
	Bookmarks := StFileBrowserBookmark defaultBookmarks
]

{ #category : 'defaults' }
StFileSystemModel class >> lastVisitedDirectory [
	"Answer a <FileLocator> representing the last visited location"

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory
]

{ #category : 'adding' }
StFileSystemModel >> addBookmark: aFileReference [ 
	"Add aFileRefefence to the global receiver's bookmarks"

	self bookmarks add: (StFileBrowserBookmark 
		name: aFileReference basename 
		location: aFileReference 
		icon: (self iconNamed: #book)).
]

{ #category : 'accessing' }
StFileSystemModel >> bookmarks [
	"Answer the receiver's <Collection> of bookmarks, each one an instance of a subclass of <StFileBrowserAbstractBookMark>"

	Bookmarks 
		ifNil: [ self class initializeBookmarks ].
	^ Bookmarks
]

{ #category : 'accessing' }
StFileSystemModel >> bookmarks: aCollectionOfGroupBookMark [
	"Set the receiver's global bookmarks to aCollectionOfGroupBookMark"

	Bookmarks := aCollectionOfGroupBookMark asOrderedCollection
]

{ #category : 'utilities' }
StFileSystemModel >> createDirectory [
	"Create a directory with a default name"

	^ self createDirectory: 'new-folder'
]

{ #category : 'utilities' }
StFileSystemModel >> createDirectory: initialName [
	"Create a directory named initialName <String>"

	| name path |
	
	(name := self requestUserDirectory: initialName) isEmptyOrNil 
		ifTrue: [ ^ self ].
	(path := currentDirectory / name) exists
		ifFalse: [ 
			(currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ self application alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ self application alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : 'accessing' }
StFileSystemModel >> currentDirectory [

	^ currentDirectory
]

{ #category : 'accessing' }
StFileSystemModel >> currentDirectory: aFileReference [

	(aFileReference exists and: [ aFileReference isDirectory ]) 
		ifFalse: [ DirectoryDoesNotExist signalWith: aFileReference ].
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : 'defaults' }
StFileSystemModel >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : 'accessing' }
StFileSystemModel >> history [
	^ history
]

{ #category : 'accessing' }
StFileSystemModel >> history: aConfigurableHistoryIterator [ 
	history := aConfigurableHistoryIterator
]

{ #category : 'initialization' }
StFileSystemModel >> initialize [
	"Private - Initialize the receiver using stored settings"

	super initialize.
	(StFileBrowserSettings showAlwaysDefaultBookmarks and: [ self bookmarks isEmpty ])
		ifTrue: [ self class initializeBookmarks ]
]

{ #category : 'accessing' }
StFileSystemModel >> lastVisitedDirectory [
	"Answer the <FileReference> of the last visited directory"

	^ self class lastVisitedDirectory.
]

{ #category : 'utilities' }
StFileSystemModel >> openFolder: aFileReference [

	self history register: self currentDirectory.
]

{ #category : 'utilities' }
StFileSystemModel >> requestUserDirectory: initialName [
	"Open a dialog to request a directory from the user"

	| answer |
	answer := [ self
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder' ]
	on: SpCancelledInteractionError
	do: [ : ex | self inform: 'Cancelled'. nil ].
	^ answer
]

{ #category : 'initialization' }
StFileSystemModel >> resetBookmarks [ 
	"Reset the global bookmarks"

	self bookmarks: nil.
]
