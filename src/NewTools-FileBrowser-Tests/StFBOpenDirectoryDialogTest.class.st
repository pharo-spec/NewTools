Class {
	#name : 'StFBOpenDirectoryDialogTest',
	#superclass : 'StFBFileDialogTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFBOpenDirectoryDialogTest >> dialogClass [
	^ StFBOpenDirectoryDialog
]

{ #category : 'tests' }
StFBOpenDirectoryDialogTest >> testDefaultDirectory [
	self assert: dialog selectedEntry equals: root.
	dialog defaultFolder: root / 'dir'.
	self assert: dialog selectedEntry equals: root / 'dir'
]

{ #category : 'tests' }
StFBOpenDirectoryDialogTest >> testSelectDirectory [

	| selectedDirectory |
	dialog okAction: [ :dir | selectedDirectory := dir ].
	window := dialog openDialog.
	self
		assert: dialog fileNavigationSystem currentDirectory
		equals: root.
	dialog selectFile: root / 'dir'.
	self
		assert: dialog selectedEntry
		equals: root / dialog fileNavigationSystem selectedEntry basename.
	window triggerOkAction.
	self assert: selectedDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StFBOpenDirectoryDialogTest >> testSelectNonexistingDirectory [

	self
		should: [ dialog defaultFolder: root / 'idontexist' ]
		raise: DirectoryDoesNotExist.
	self assert: dialog currentDirectory equals: root
]
