Class {
	#name : 'StOpenDirectoryPresenterTest',
	#superclass : 'StFilePresenterTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StOpenDirectoryPresenterTest >> dialogClass [

	^ StOpenDirectoryPresenter
]

{ #category : 'tests' }
StOpenDirectoryPresenterTest >> testDefaultDirectory [

	self assert: root isDirectory.
	self assert: dialog selectedEntry equals: root.
	dialog defaultFolder: root / 'dir'.
	self assert: dialog selectedEntry equals: root / 'dir'
]

{ #category : 'tests' }
StOpenDirectoryPresenterTest >> testSelectDirectory [

	| selectedDirectory |
	
	window := dialog openDialog.
	self
		assert: dialog fileNavigationSystem currentDirectory
		equals: root.
	dialog selectFile: root / 'dir'.
	self
		assert: dialog selectedEntry
		equals: root / dialog fileNavigationSystem selectedEntry basename.
		
	selectedDirectory := window triggerOkAction.
	
	self assert: selectedDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StOpenDirectoryPresenterTest >> testSelectNonexistingDirectory [

	self
		should: [ dialog defaultFolder: root / 'idontexist' ]
		raise: DirectoryDoesNotExist.
	self assert: dialog currentDirectory equals: root
]

{ #category : 'tests' }
StOpenDirectoryPresenterTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.

	"Since we're only displaying directories, no files should appear in the reference table"
	self assertEmpty: dialog fileReferenceTable items
]
