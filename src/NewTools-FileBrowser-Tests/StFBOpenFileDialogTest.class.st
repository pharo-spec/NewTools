Class {
	#name : #StFBOpenFileDialogTest,
	#superclass : #StFBFileDialogTest,
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #accessing }
StFBOpenFileDialogTest >> dialogClass [
	^ StFBOpenFileDialog
]

{ #category : #tests }
StFBOpenFileDialogTest >> testArrayFilters [
	dialog fileFilters: #('*.ston' '*.image').
	self assert: dialog fileFilters equals: {'*.ston, *.image' -> #('*.ston' '*.image')}
]

{ #category : #tests }
StFBOpenFileDialogTest >> testExtensions [
	dialog extensionFilters: {'Ext files' -> #(ext)}.
	self assert: dialog fileFilters equals: {'Ext files (*.ext)' -> #('*.ext')}
]

{ #category : #tests }
StFBOpenFileDialogTest >> testSelectFile [
	| selectedFile |
	dialog okAction: [ :file | selectedFile := file ].
	window := dialog openDialogWithSpec.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.
	dialog confirm.
	self assert: selectedFile equals: root / 'sth.ext'
]
