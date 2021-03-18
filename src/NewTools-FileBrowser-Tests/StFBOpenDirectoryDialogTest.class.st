Class {
	#name : #StFBOpenDirectoryDialogTest,
	#superclass : #StFBFileDialogTest,
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #accessing }
StFBOpenDirectoryDialogTest >> dialogClass [
	^ StFBOpenDirectoryDialog
]

{ #category : #tests }
StFBOpenDirectoryDialogTest >> testDefaultDirectory [
	self assert: dialog selectedEntry equals: root.
	dialog defaultFolder: root / 'dir'.
	self assert: dialog selectedEntry equals: root / 'dir'
]

{ #category : #tests }
StFBOpenDirectoryDialogTest >> testSelectDirectory [
	| selectedDirectory |
	dialog okAction: [ :dir | selectedDirectory := dir ].
	window := dialog openDialogWithSpec.
	self assert: dialog fileNavigationSystem currentDirectory equals: root.
	dialog selectFile: root / 'dir'.
	self assert: dialog selectedEntry equals: root / dialog fileNavigationSystem selectedEntry basename.
	window triggerOkAction.
	self assert: selectedDirectory equals: root / 'dir'
]

{ #category : #tests }
StFBOpenDirectoryDialogTest >> testSelectNonexistingDirectory [
	dialog defaultFolder: root / 'idontexist'.
	self assert: dialog selectedEntry equals: FileLocator imageDirectory asFileReference
]
