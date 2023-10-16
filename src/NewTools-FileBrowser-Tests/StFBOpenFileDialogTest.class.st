Class {
	#name : 'StFBOpenFileDialogTest',
	#superclass : 'StFBFileDialogTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFBOpenFileDialogTest >> dialogClass [
	^ StFBOpenFileDialog
]

{ #category : 'tests' }
StFBOpenFileDialogTest >> testExtensions [

	dialog extensions: #( ext ) named: 'Ext files'.
	self
		assertCollection:
		dialog fileNavigationSystem filtersDropList selectedItem extensions
		equals: #( ext ).
	self
		assert:
		dialog fileNavigationSystem filtersDropList selectedItem basename
		equals: 'Ext files'
]

{ #category : 'tests' }
StFBOpenFileDialogTest >> testMultipleExtensions [

	dialog extensions: #( image changes sources ) named: 'Src files'.
	self
		assertCollection:
		dialog fileNavigationSystem filtersDropList selectedItem extensions
		equals: #( image changes sources ).
	self
		assert:
		dialog fileNavigationSystem filtersDropList selectedItem basename
		equals: 'Src files'
]

{ #category : 'tests' }
StFBOpenFileDialogTest >> testSelectFile [

	| selectedFile |
	dialog okAction: [ :file | selectedFile := file ].
	window := dialog openDialog.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.
	dialog confirm.
	self assert: selectedFile equals: root / 'sth.ext'
]
