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
