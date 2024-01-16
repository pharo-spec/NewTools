Class {
	#name : 'StFileDialogTest',
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
StFileDialogTest class >> isAbstract [
	^ self = StFileDialogTest
]

{ #category : 'accessing' }
StFileDialogTest >> dialogClass [
	^ self subclassResponsibility
]

{ #category : 'tests' }
StFileDialogTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : 'running' }
StFileDialogTest >> setUp [
	super setUp.
	(dialog := self dialogClass owner: fileSystemPresenter on: fileSystemModel) defaultFolder: root
]

{ #category : 'running' }
StFileDialogTest >> tearDown [

	dialog class initialize.
	window ifNotNil: [ : w | w delete ].
	super tearDown
]

{ #category : 'tests' }
StFileDialogTest >> testIsRootDirectory [
	self assert: (dialog isRootDirectory: FileLocator root)
]

{ #category : 'tests' }
StFileDialogTest >> testIsRootDirectoryWindowsDrive [
	OSPlatform current isWindows
		ifFalse: [ ^ self ].
	self assert: (dialog isRootDirectory: FileLocator C)
]

{ #category : 'tests' }
StFileDialogTest >> testOpen [

	"will it even open?"

	window := dialog openDialog
]

{ #category : 'tests' }
StFileDialogTest >> testOpenFolder [
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog showDirectory: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StFileDialogTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |
	aCollectionOfBookmark := {(root / 'dir') asFileReference.
	(root / 'dir.ext') asFileReference}
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
StFileDialogTest >> testWhenAddingBookmarkOnDefaultBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	anOtherInstance := StOpenDirectoryDialog new.
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
StFileDialogTest >> testWhenAddingBookmarkOnIsolateBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	dialog isolate.
	addCommand := StFileBrowserAddBookmarkCommand new.
	addCommand context: dialog fileNavigationSystem.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	anOtherInstance := StOpenDirectoryDialog new.
	self 
		assert: anOtherInstance bookmarks 
		equals: dialog bookmarks.
	self
		assert: dialog bookmarksTreeTable roots
		equals: anOtherInstance bookmarksTreeTable roots
]

{ #category : 'tests' }
StFileDialogTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
