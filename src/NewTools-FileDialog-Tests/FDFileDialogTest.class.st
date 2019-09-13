Class {
	#name : #FDFileDialogTest,
	#superclass : #FDTestCase,
	#instVars : [
		'dialog',
		'window'
	],
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #testing }
FDFileDialogTest class >> isAbstract [
	^ self = FDFileDialogTest
]

{ #category : #accessing }
FDFileDialogTest >> dialogClass [
	^ self subclassResponsibility
]

{ #category : #tests }
FDFileDialogTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : #running }
FDFileDialogTest >> setUp [
	super setUp.
	(dialog := self dialogClass new) defaultFolder: root
]

{ #category : #running }
FDFileDialogTest >> tearDown [
	dialog class initialize.
	window ifNotNil: #delete.
	super tearDown
]

{ #category : #tests }
FDFileDialogTest >> testIsRootDirectory [
	self assert: (dialog isRootDirectory: FileLocator root)
]

{ #category : #tests }
FDFileDialogTest >> testIsRootDirectoryWindowsDrive [
	OSPlatform current isWindows
		ifFalse: [ ^ self ].
	self assert: (dialog isRootDirectory: FileLocator C)
]

{ #category : #tests }
FDFileDialogTest >> testOpen [
	"will it even open?"
	window := dialog openDialogWithSpec.
]

{ #category : #tests }
FDFileDialogTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |
	aCollectionOfBookmark := {(root / 'dir') asFileReference.
	(root / 'dir.ext') asFileReference}
		collect:
			[ :eachItem | FDBookmark name: eachItem basename location: eachItem path icon: nil ].
	dialog
		bookmarks:
			{(FDGroupBookmark
				name: 'aTestBookmark'
				collection: aCollectionOfBookmark
				iconName: '')}.
	self
		assertCollection: (dialog bookmarksTreeTable roots at: 1) collection
		hasSameElements: aCollectionOfBookmark.
	self assert: dialog bookmarksTreeTable roots size equals: 1
]

{ #category : #tests }
FDFileDialogTest >> testWhenAddingBookmarkOnDefaultBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	anOtherInstance := FDOpenDirectoryDialog new.
	self
		assertCollection: anOtherInstance bookmarks
		hasSameElements: dialog bookmarks.
	addCommand := FDAddBookmarkCommand new.
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
FDFileDialogTest >> testWhenAddingBookmarkOnIsolateBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	dialog isolate.
	addCommand := FDAddBookmarkCommand new.
	addCommand context: dialog fileNavigationSystem.
	dialog fileReferenceTable
		selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	anOtherInstance := FDOpenDirectoryDialog new.
	self flag: #issue4162.
	self deny: anOtherInstance bookmarks equals: dialog bookmarks.
	self
		deny: dialog bookmarksTreeTable roots
		equals: anOtherInstance bookmarksTreeTable roots
]

{ #category : #tests }
FDFileDialogTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
