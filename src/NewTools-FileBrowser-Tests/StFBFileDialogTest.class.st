Class {
	#name : #StFBFileDialogTest,
	#superclass : #StFBTestCase,
	#instVars : [
		'dialog',
		'window'
	],
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #testing }
StFBFileDialogTest class >> isAbstract [
	^ self = StFBFileDialogTest
]

{ #category : #accessing }
StFBFileDialogTest >> dialogClass [
	^ self subclassResponsibility
]

{ #category : #tests }
StFBFileDialogTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : #running }
StFBFileDialogTest >> setUp [
	super setUp.
	(dialog := self dialogClass new) defaultFolder: root
]

{ #category : #running }
StFBFileDialogTest >> tearDown [
	dialog class initialize.
	window ifNotNil: #delete.
	super tearDown
]

{ #category : #tests }
StFBFileDialogTest >> testIsRootDirectory [
	self assert: (dialog isRootDirectory: FileLocator root)
]

{ #category : #tests }
StFBFileDialogTest >> testIsRootDirectoryWindowsDrive [
	OSPlatform current isWindows
		ifFalse: [ ^ self ].
	self assert: (dialog isRootDirectory: FileLocator C)
]

{ #category : #tests }
StFBFileDialogTest >> testOpen [

	"will it even open?"

	window := dialog openDialog
]

{ #category : #tests }
StFBFileDialogTest >> testOpenFolder [
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog showDirectory: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : #tests }
StFBFileDialogTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |
	aCollectionOfBookmark := {(root / 'dir') asFileReference.
	(root / 'dir.ext') asFileReference}
		collect:
			[ :eachItem | StFBBookmark name: eachItem basename location: eachItem path icon: nil ].
	dialog
		bookmarks:
			{(StFBGroupBookmark
				name: 'aTestBookmark'
				collection: aCollectionOfBookmark
				iconName: '')}.
	self
		assertCollection: (dialog bookmarksTreeTable roots at: 1) collection
		hasSameElements: aCollectionOfBookmark.
	self assert: dialog bookmarksTreeTable roots size equals: 1
]

{ #category : #tests }
StFBFileDialogTest >> testWhenAddingBookmarkOnDefaultBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	anOtherInstance := StFBOpenDirectoryDialog new.
	self
		assertCollection: anOtherInstance bookmarks
		hasSameElements: dialog bookmarks.
	addCommand := StFBAddBookmarkCommand new.
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

{ #category : #tests }
StFBFileDialogTest >> testWhenAddingBookmarkOnIsolateBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	dialog isolate.
	addCommand := StFBAddBookmarkCommand new.
	addCommand context: dialog fileNavigationSystem.
	dialog fileReferenceTable
		selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	anOtherInstance := StFBOpenDirectoryDialog new.
	self flag: #issue4162.
	self deny: anOtherInstance bookmarks equals: dialog bookmarks.
	self
		deny: dialog bookmarksTreeTable roots
		equals: anOtherInstance bookmarksTreeTable roots
]

{ #category : #tests }
StFBFileDialogTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
