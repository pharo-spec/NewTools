Class {
	#name : 'StFileSystemModelTest',
	#superclass : 'StFileBrowserSharedStateTestCase',
	#category : 'NewTools-FileBrowser-Tests-Utils',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Utils'
}

{ #category : 'tests' }
StFileSystemModelTest >> testCreateDirectory [

	| model fileRef |
	model := StFileSystemModel new.
	model currentDirectory: self temporaryDirectory.
	model history: ConfigurableHistoryIterator new.

	fileRef := self temporaryDirectory / 'abc'.
	
	model createDirectory: 'abc'.

	self assert: fileRef exists.
	self assert: fileRef isDirectory
]

{ #category : 'tests' }
StFileSystemModelTest >> testCreateDirectoryShouldNotDuplicateFile [

	| model fileRef |
	model := StFileSystemModel new.
	model currentDirectory: self temporaryDirectory.

	fileRef := self temporaryDirectory / 'abc'.
	fileRef ensureCreateFile .
	self should: [ model createDirectory: 'abc' ] raise: Error description: 'A file with that name already exists.'
]

{ #category : 'tests' }
StFileSystemModelTest >> testCreateDirectoryShouldNotDuplicateFolder [

	| model fileRef |
	model := StFileSystemModel new.
	model currentDirectory: self temporaryDirectory.

	fileRef := self temporaryDirectory / 'abc'.
	fileRef ensureCreateDirectory.
	self should: [ model createDirectory: 'abc' ] raise: Error description: 'A folder with that name already exists.'
]

{ #category : 'tests' }
StFileSystemModelTest >> testCreateDirectoryShouldNotWorkWithEmptyName [

	| model |
	model := StFileSystemModel new.
	self assert: (model createDirectory: '') equals: model.
	self assert: (model createDirectory: nil) equals: model.
]

{ #category : 'tests - shared state' }
StFileSystemModelTest >> testRestoreSharedStateRemovesABookmarkAddedToAGroup [

	| saved size |
	saved := StFileSystemModel sharedState.
	size := StFileSystemModel bookmarks first children size.
	StFileSystemModel addBookmarkNamed: 'image' location: FileLocator imageDirectory iconName: #book.
	StFileSystemModel restoreSharedState: saved.
	self assert: StFileSystemModel bookmarks first children size equals: size
]

{ #category : 'tests - shared state' }
StFileSystemModelTest >> testRestoreSharedStateRemovesAnAddedBookmark [

	| saved size |
	saved := StFileSystemModel sharedState.
	size := StFileSystemModel bookmarks size.
	StFileSystemModel new addBookmark: FileLocator imageDirectory asFileReference.
	StFileSystemModel restoreSharedState: saved.
	self assert: StFileSystemModel bookmarks size equals: size
]

{ #category : 'tests - shared state' }
StFileSystemModelTest >> testRestoreSharedStateRestoresTheLastVisitedDirectory [

	| saved directory |
	directory := FileLocator imageDirectory asFileReference.
	StFileSystemModel new currentDirectory: directory.
	saved := StFileSystemModel sharedState.
	StFileSystemModel new currentDirectory: FileLocator workingDirectory asFileReference parent.
	StFileSystemModel restoreSharedState: saved.
	self assert: StFileSystemModel lastVisitedDirectory equals: directory
]
