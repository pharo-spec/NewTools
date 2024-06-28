Class {
	#name : 'StOpenFilePresenterTest',
	#superclass : 'StFilePresenterTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StOpenFilePresenterTest >> dialogClass [

	^ StOpenFilePresenter
]

{ #category : 'tests' }
StOpenFilePresenterTest >> testExtensions [

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
StOpenFilePresenterTest >> testMultipleExtensions [

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
StOpenFilePresenterTest >> testSelectFile [

	| selectedFile |

	window := dialog openDialog.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.

	selectedFile := dialog confirm.
	
	self assert: selectedFile equals: root / 'sth.ext'
]

{ #category : 'tests' }
StOpenFilePresenterTest >> testSelectedEntriesMultipleSelection [

	window := dialog openDialog.
	dialog selectFiles: { root / 'sth.ext' . root / 'patate.png' }.
	self 
		assertCollection: dialog selectedEntries 
		hasSameElements: { root / 'sth.ext' . root / 'patate.png' }.

]

{ #category : 'tests' }
StOpenFilePresenterTest >> testSelectedEntriesSingleSelection [

	window := dialog openDialog.
	dialog selectFile: root / 'sth.ext'.
	self assertCollection: dialog selectedEntries hasSameElements: { root / 'sth.ext' }.

]

{ #category : 'tests' }
StOpenFilePresenterTest >> testSetTitle [

	dialog title: 'test set title'.
	self
		assertCollection: dialog title
		equals: 'test set title'.
]

{ #category : 'tests' }
StOpenFilePresenterTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
