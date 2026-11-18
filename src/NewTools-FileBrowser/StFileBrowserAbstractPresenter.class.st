"
I am the root of the presenters of the file browser and of the file dialogs (open a file, open a folder, save a file). A browser or a dialog is made of a few presenters, all subclasses of mine, sharing one `StFileSystemModel`.

## Life cycle: who creates the presenters and who uses them

1. **Someone opens a browser or a dialog.** The World menu item System > File Browser (`StFileBrowserAbstractPresenter class>>menuFileSystemBrowserCommandOn:`) opens a `StFileSystemPresenter`, also registered as the `#fileList` tool. Code asking the user for a file or a folder opens a dialog: `StOpenFilePresenter`, `StOpenDirectoryPresenter` or `StSaveFilePresenter`, usually with `openModal` (e.g. `StLabeledSettingFileSelectionPresenter`, `IceTipFilePresenter`, `EpChunkExporter`). `SpMorphicBackend` and the `UITheme` file services open them too.
2. **Each presenter gets the model.** `initialize` sets `StFileBrowserAbstractPresenter class>>defaultModel`, a new `StFileSystemModel`, unless one is given (`on:`, `owner:on:`). The subpresenters are created on the model of their owner, so they share the current directory and the history.
3. **The browser assembles its parts.** `StFileSystemPresenter>>initializePresenters` creates the navigation presenter (its `navigationSystemClass`: `StFileNavigationSystemPresenter`, or `StDirectoryNavigationSystemPresenter` for folder dialogs), the directory tree (`StDirectoryTreePresenter`) and the bookmark tree. The navigation presenter creates the path bar (`StPathBreadcrumbPresenter`), the file table, the filter drop list, the name field and the preview pane.
4. **Navigation goes through the model and the owner.** Selecting a folder in the tree, a bookmark, a link of the path or double clicking a folder ends in `openFolder:` / `updateWidgetWithFileReference:`: the model changes its `currentDirectory` and records it in its history (back and forward buttons), and the table, path and tree are updated. A subpresenter sends to its `owner` what concerns the whole browser: `updateFileSystemPresenters`, `addBookmark:`, `bookmarks:`, `bookmarksTreeTable`.
5. **A dialog gives the choice.** When the user confirms, a dialog evaluates its `okAction:` block with its `selectedEntry`. The open dialogs also answer their `selectedEntries` from `openModal` (nil when cancelled); the save dialog answers its window, so its users rely on `okAction:` (e.g. `EpChunkExporter>>fileOut:in:`).

## Responsibility:

- Hold the `StFileSystemModel` and give access to its current directory, history, bookmarks and default and last visited directories.
- Create folders (`createDirectory`, asking the name), and set up the history of a starting folder.
- Define what each presenter must do when a folder is opened (`openFolder:`, `updateWidgetWithFileReference:`).

## Collaborators:

- `StFileSystemModel`: my model, shared by the presenters of a browser.
- `StFileBrowserSettings`: tells whether to open on the last visited directory.
- My subclasses: the parts of a browser and the dialogs.

## Public API and Key Messages

- `openFolder: aFileReference`, `updateWidgetWithFileReference: aFileReference`: show a folder. Subclasses define them.
- `currentDirectory`, `currentDirectory:`, `history`, `bookmarks`, `defaultDirectory`, `lastVisitedDirectory`.
- `createDirectory`, `updateFileSystemPresenters`.
- `StFileBrowserAbstractPresenter class>>open`: opens a new instance.

## Examples

```smalltalk
StFileSystemPresenter open.
StOpenFilePresenter example.
```

The first opens the file browser, the second an open file dialog that inspects the chosen file.

## Internal Representation

- `model`: the `StFileSystemModel`.
"
Class {
	#name : 'StFileBrowserAbstractPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'model'
	],
	#classVars : [
		'Bookmarks'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'instance creation' }
StFileBrowserAbstractPresenter class >> defaultModel [

	^ StFileSystemModel new
]

{ #category : 'world menu' }
StFileBrowserAbstractPresenter class >> menuFileSystemBrowserCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #NewFileBrowser)
		parent: #System;
		action: [ StFileSystemPresenter open ];
		label: 'File Browser';
		order: 1;
		help: 'Open the File Browser.';
		iconName: #smallOpen
]

{ #category : 'instance creation' }
StFileBrowserAbstractPresenter class >> open [

	^ self new open
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> addBookmark: aFileReference [ 

	self owner addBookmark: aFileReference.


]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks [

	^ self model bookmarks.
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarks: aCollectionOfFDGroupBookMark [

	self owner bookmarks: aCollectionOfFDGroupBookMark
]

{ #category : 'accessing - bookmarks' }
StFileBrowserAbstractPresenter >> bookmarksTreeTable [
	"Answer a <SpTreeTablePresenter> used to display the receiver's bookmarks"

	^ self owner bookmarksTreeTable
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> createDirectory [

	[ self model createDirectory: (self requestDirectoryName: 'default-directory') ]
		on: Error
		do: [ :ex | self application alert: ex messageText ].
	self updateFileSystemPresenters
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

	^ self model defaultDirectory
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

	model ifNil: [ self setModelBeforeInitialization: self class defaultModel ].
	super initialize
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

{ #category : 'hooks' }
StFileBrowserAbstractPresenter >> navigationSystemClass [

	^ self class navigationSystemClass
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> openFolder: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> openOnLastDirectory [ 
	"Answer <true> if receiver should open in the last used directory"
	
	^ StFileBrowserSettings openOnLastDirectory
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> requestDirectoryName: defaultName [
	"Open a dialog to request a directory from the user"

	| answer |
	answer := [ self
		request: 'Folder name'
		initialAnswer: defaultName
		title: 'Create New Folder' ]
	on: SpCancelledInteractionError
	do: [ :ex | self inform: 'Cancelled'. nil ].
	^ answer
]

{ #category : 'initialization' }
StFileBrowserAbstractPresenter >> resetBookmarks [
	"Reset bookmarks to their defaults"

	self model resetBookmarks
]

{ #category : 'accessing - model' }
StFileBrowserAbstractPresenter >> setModelBeforeInitialization: aStFileSystemModel [

	model := aStFileSystemModel
]

{ #category : 'utilities' }
StFileBrowserAbstractPresenter >> updateFileSystemPresenters [

	self owner updateFileSystemPresenters
]

{ #category : 'accessing - history' }
StFileBrowserAbstractPresenter >> updateWidgetWithFileReference: aFileReference [

	self subclassResponsibility
]
