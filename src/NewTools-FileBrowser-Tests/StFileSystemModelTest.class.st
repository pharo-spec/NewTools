Class {
	#name : 'StFileSystemModelTest',
	#superclass : 'TestCase',
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
