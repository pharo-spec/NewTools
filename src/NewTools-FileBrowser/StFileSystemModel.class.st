"
I am the model of the file browser and the dialogs: the current folder and its history for one browser, and, shared by all browsers, the bookmarks and the last visited folder.

## Life cycle: who creates me and who uses me

1. `StFileBrowserAbstractPresenter class>>defaultModel` creates me for each browser or dialog (or the code opening one gives me with `on:`), and all its presenters share me.
2. The presenters change my `currentDirectory` when the user opens a folder; I check that it is an existing folder and remember it as the last visited one.
3. `openFolder:` records the current folder in my `history`, a `ConfigurableHistoryIterator` set up by the presenters (back and forward buttons).
4. My class side keeps the bookmarks of all the dialogs (see `StFileBrowserAbstractBookMark`) and the last visited folder, used when `StFileBrowserSettings openOnLastDirectory`.

## Responsibility:

- Know the current folder and its history.
- Create a folder in the current one (`createDirectory:`), refusing a name already used.
- Keep the shared bookmarks and the last visited folder, and give the default folder of the settings.

## Collaborators:

- `StFileBrowserAbstractPresenter` and its subclasses: my users.
- `StFileBrowserBookmark`: the default bookmarks.
- `StFileBrowserSettings`: the default folder and whether to keep the default bookmarks.

## Public API and Key Messages

- `currentDirectory`, `currentDirectory: aFileReference` (signals `DirectoryDoesNotExist` for a missing folder).
- `history`, `history:`, `openFolder: aFileReference`.
- `createDirectory: aString`.
- `bookmarks`, `addBookmark: aFileReference`, `resetBookmarks`, `StFileSystemModel addBookmarkNamed:location:iconName:`.
- `defaultDirectory`, `lastVisitedDirectory`.
- `StFileSystemModel sharedState`, `StFileSystemModel restoreSharedState: aState`: copy and restore the shared bookmarks and last visited directory; the tests use them (`StFileBrowserSharedStateTestCase`) to leave the dialogs as they found them.

## Examples

```smalltalk
StFileSystemModel exampleOnWorkingDirectory.
```

## Internal Representation

- `currentDirectory`: a `FileReference`.
- `history`: a `ConfigurableHistoryIterator` on the visited folders.
- `Bookmarks`: class variable, the shared bookmarks.
- `LastVisitedDirectory`: class variable, the last folder set as current directory, by any browser.
"
Class {
	#name : 'StFileSystemModel',
	#superclass : 'Model',
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

{ #category : 'adding' }
StFileSystemModel class >> addBookmarkNamed: aString location: aLocation iconName: aName [
	"Example: `StFileSystemModel addBookmarkNamed: 'pharo' location: FileLocator preferences / 'pharo' iconName: #git`"

	self bookmarks anyOne addBookmark: (StFileBrowserBookmark name: aString location: aLocation icon: (self iconNamed: aName))
]

{ #category : 'accessing - bookmarks' }
StFileSystemModel class >> bookmarks [

	^ Bookmarks ifNil: [
			  self initializeBookmarks.
			  Bookmarks ]
]

{ #category : 'defaults' }
StFileSystemModel class >> defaultDirectory [
	"Answer a <FileReference> with the default directory for opening the file browser and dialogs"

	^ StFileBrowserSettings defaultDirectory.
]

{ #category : 'examples' }
StFileSystemModel class >> exampleOnWorkingDirectory [

	<sampleInstance>
	^ self new
		  currentDirectory: FileLocator workingDirectory asFileReference;
		  yourself
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

{ #category : 'accessing - shared state' }
StFileSystemModel class >> restoreSharedState: anArray [
	"Set the state shared by all the file browsers and dialogs back to anArray, answered by sharedState."

	Bookmarks := anArray first.
	LastVisitedDirectory := anArray second
]

{ #category : 'accessing - shared state' }
StFileSystemModel class >> sharedState [
	"Answer a copy of the state shared by all the file browsers and dialogs, the bookmarks and the last visited directory, to give back to restoreSharedState:. Tests use it to leave this state as they found it."

	^ {
		  (Bookmarks ifNotNil: [ :bookmarks | bookmarks collect: [ :each | each copy ] ]).
		  LastVisitedDirectory }
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

	^ self class bookmarks
]

{ #category : 'accessing' }
StFileSystemModel >> bookmarks: aCollectionOfGroupBookMark [
	"Set the receiver's global bookmarks to aCollectionOfGroupBookMark"

	Bookmarks := aCollectionOfGroupBookMark ifNotNil: [ aCollectionOfGroupBookMark asOrderedCollection ]
]

{ #category : 'utilities' }
StFileSystemModel >> createDirectory: name [
	"Create a directory named initialName <String>"

	| path |
	name isEmptyOrNil ifTrue: [ ^ self ].

	path := currentDirectory / name.
	path isDirectory ifTrue: [ self error: 'A folder with that name already exists.' ].
	path isFile ifTrue: [ self error: 'A file with that name already exists.' ].

	path exists ifTrue: [ ^ self ].
	(currentDirectory / name) ensureCreateDirectory.
	self openFolder: currentDirectory
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

{ #category : 'initialization' }
StFileSystemModel >> resetBookmarks [ 
	"Reset the global bookmarks"

	self bookmarks: nil.
]
