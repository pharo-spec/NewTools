"
I test the file browser, `StFileSystemPresenter`, opened in a window.

## Responsibility:

- Check that the directory tree and the file table show the same folder when the browser opens and after a folder is opened.

## Collaborators:

- `StFileSystemPresenter`: the browser under test, opened and closed by each test.
- `StDirectoryTreePresenter`: its directory tree.
"
Class {
	#name : 'StFileSystemPresenterTest',
	#superclass : 'StFileBrowserSharedStateTestCase',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'tests' }
StFileSystemPresenterTest >> testOpenedBrowserTreeShowsAnOpenedFolder [

	| browser window |
	browser := StFileSystemPresenter new.
	window := browser open.
	[
		self currentWorld doOneCycle.
		browser openFolder: browser currentDirectory.
		self currentWorld doOneCycle.
		self assert: browser treeNavigationSystem selectedEntry equals: browser currentDirectory ] ensure: [ window close ]
]

{ #category : 'tests' }
StFileSystemPresenterTest >> testOpenedBrowserTreeShowsTheCurrentDirectory [

	| browser window |
	browser := StFileSystemPresenter new.
	window := browser open.
	[
		self currentWorld doOneCycle.
		self assert: browser treeNavigationSystem directoryTreePresenter selectedItem isNotNil.
		self assert: browser treeNavigationSystem selectedEntry equals: browser currentDirectory ] ensure: [ window close ]
]
