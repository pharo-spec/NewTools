"
I test the file browser, `StFileSystemPresenter`, opened in a window.

## Responsibility:

- Check that the directory tree and the file table show the same folder when the browser opens and after a folder is opened.

## Collaborators:

- `StFileSystemPresenter`: the browser under test (`browser`), created in `setUp`, opened by each test and closed in `tearDown`.
- `StDirectoryTreePresenter`: its directory tree.
"
Class {
	#name : 'StFileSystemPresenterTest',
	#superclass : 'StFileBrowserSharedStateTestCase',
	#instVars : [
		'browser'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
StFileSystemPresenterTest >> setUp [

	super setUp.
	browser := StFileSystemPresenter new
]

{ #category : 'running' }
StFileSystemPresenterTest >> tearDown [

	browser withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testBackAfterOpeningTheShownFolderAgainShowsThePreviousFolder [
	"Opening the folder already shown, as from the last link of the path bar or a bookmark, must not record it twice: one Back is enough to leave it."

	| folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser openFolder: folder parent.
	browser openFolder: folder.
	browser openFolder: folder.
	browser fileNavigationSystem previousButton click.
	self assert: browser currentDirectory equals: folder parent
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testBackAfterSelectingAFolderInTheTreeShowsThePreviousFolder [

	| folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser openFolder: folder.
	browser treeNavigationSystem expandPath: folder parent.
	browser fileNavigationSystem previousButton click.
	self assert: browser currentDirectory equals: folder
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testBackAfterTheTreeOpensAFolderShowsThePreviousFolder [
	"The tree opens a folder itself when a folder is removed from its context menu: it moves to the parent."

	| folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser openFolder: folder.
	browser treeNavigationSystem openFolder: folder parent.
	browser openFolder: folder parent parent.
	browser fileNavigationSystem previousButton click.
	self assert: browser currentDirectory equals: folder parent
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testForwardAfterOpeningTheShownFolderAgainShowsTheNextFolder [
	"Opening the folder already shown does not move anywhere, so it keeps the folders the forward button returns to."

	| folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser openFolder: folder parent.
	browser openFolder: folder.
	browser fileNavigationSystem previousButton click.
	browser openFolder: folder parent.
	browser fileNavigationSystem nextButton click.
	self assert: browser currentDirectory equals: folder
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testOpenedBrowserTreeShowsAnOpenedFolder [

	browser open.
	browser openFolder: browser currentDirectory.
	self assert: browser treeNavigationSystem selectedEntry equals: browser currentDirectory
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testOpenedBrowserTreeShowsTheCurrentDirectory [

	browser open.
	self assert: browser treeNavigationSystem directoryTreePresenter selectedItem isNotNil.
	self assert: browser treeNavigationSystem selectedEntry equals: browser currentDirectory
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testOpeningAFolderFillsTheFileTableOnce [
	"Opening a folder selects it in the directory tree, which must not show the folder a second time."

	| fills table folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser fileNavigationSystem openFolder: folder.
	table := browser fileNavigationSystem fileReferenceTable.
	fills := 0.
	table whenModelChangedDo: [ fills := fills + 1 ].
	browser fileNavigationSystem openFolder: folder parent.
	self assert: fills equals: 1
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testSelectingAFolderInTheTreeShowsIt [

	| folder |
	browser open.
	folder := FileLocator imageDirectory asFileReference.
	browser openFolder: folder.
	browser treeNavigationSystem expandPath: folder parent.
	self assert: browser currentDirectory equals: folder parent
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testShowFolderShowsItInTheFileTable [

	| folder |
	folder := FileLocator imageDirectory asFileReference.
	browser showFolder: folder.
	self assert: browser fileNavigationSystem currentDirectory equals: folder
]
