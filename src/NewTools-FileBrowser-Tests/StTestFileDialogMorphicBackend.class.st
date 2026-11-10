"
A Morphic backend that does not open file dialogs: I answer the result given to me, as StFileDialogPresenter>>#openModal would.
"
Class {
	#name : 'StTestFileDialogMorphicBackend',
	#superclass : 'SpMorphicBackend',
	#instVars : [
		'dialogResult'
	],
	#category : 'NewTools-FileBrowser-Tests-Utils',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Utils'
}

{ #category : 'accessing' }
StTestFileDialogMorphicBackend >> dialogResult: anObject [

	dialogResult := anObject
]

{ #category : 'private - dialogs' }
StTestFileDialogMorphicBackend >> newFileDialogFor: aFileDialog [

	^ self
]

{ #category : 'private - dialogs' }
StTestFileDialogMorphicBackend >> openModal [

	^ dialogResult
]
