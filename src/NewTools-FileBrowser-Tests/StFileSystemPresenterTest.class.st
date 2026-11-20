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
