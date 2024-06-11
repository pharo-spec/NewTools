Class {
	#name : 'StFilePresenterTest',
	#superclass : 'StFileBrowserTestCase',
	#instVars : [
		'dialog',
		'window'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'testing' }
StFilePresenterTest class >> isAbstract [
	^ self = StFilePresenterTest
]

{ #category : 'accessing' }
StFilePresenterTest >> dialogClass [
	^ self subclassResponsibility
]

{ #category : 'tests' }
StFilePresenterTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : 'running' }
StFilePresenterTest >> setUp [

	super setUp.
	(dialog := self dialogClass owner: fileSystemPresenter on: fileSystemModel) defaultFolder: root
]

{ #category : 'running' }
StFilePresenterTest >> tearDown [

	dialog class initialize.
	window ifNotNil: [ : w | w delete ].
	super tearDown
]

{ #category : 'tests' }
StFilePresenterTest >> testIsRootDirectory [
	self assert: (dialog isRootDirectory: FileLocator root)
]

{ #category : 'tests' }
StFilePresenterTest >> testIsRootDirectoryWindowsDrive [
	OSPlatform current isWindows
		ifFalse: [ ^ self ].
	self assert: (dialog isRootDirectory: FileLocator C)
]

{ #category : 'tests' }
StFilePresenterTest >> testOpen [

	"will it even open?"

	window := dialog openDialog
]

{ #category : 'tests' }
StFilePresenterTest >> testOpenFolder [
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog showDirectory: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StFilePresenterTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |

	aCollectionOfBookmark := {
		(root / 'dir') asFileReference.
		(root / 'dir.ext') asFileReference }
			collect: [ :eachItem | StFileBrowserBookmark name: eachItem basename location: eachItem path icon: nil ].

	dialog bookmarks: { (StFileBrowserGroupBookmark
				name: 'aTestBookmark'
				collection: aCollectionOfBookmark
				iconName: '') }.
	self
		assertCollection: (dialog bookmarksTreeTable roots at: 1) collection
		hasSameElements: aCollectionOfBookmark.
	self assert: dialog bookmarksTreeTable roots size equals: 1
]

{ #category : 'tests' }
StFilePresenterTest >> testWhenAddingBookmarkOnDefaultBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	anOtherInstance := StOpenDirectoryPresenter new.
	self
		assertCollection: anOtherInstance bookmarks
		hasSameElements: dialog bookmarks.
	addCommand := StFileBrowserAddBookmarkCommand new.
	addCommand context: dialog fileNavigationSystem.
	dialog fileReferenceTable
		selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	addCommand execute.
	self
		assertCollection: dialog bookmarksTreeTable roots
		hasSameElements: anOtherInstance bookmarks.
	self
		assertCollection: dialog bookmarksTreeTable roots
		hasSameElements: anOtherInstance bookmarksTreeTable roots
]

{ #category : 'tests' }
StFilePresenterTest >> testWhenAddingBookmarkOnIsolateBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	dialog isolate.
	addCommand := StFileBrowserAddBookmarkCommand new.
	addCommand context: dialog fileNavigationSystem.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	anOtherInstance := StOpenDirectoryPresenter new.
	self 
		assert: anOtherInstance bookmarks 
		equals: dialog bookmarks.
	self
		assert: dialog bookmarksTreeTable roots
		equals: anOtherInstance bookmarksTreeTable roots
]
