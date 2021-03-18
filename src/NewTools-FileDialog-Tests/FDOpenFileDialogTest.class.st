Class {
	#name : #FDOpenFileDialogTest,
	#superclass : #FDFileDialogTest,
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #accessing }
FDOpenFileDialogTest >> dialogClass [
	^ FDOpenFileDialog
]

{ #category : #tests }
FDOpenFileDialogTest >> testArrayFilters [
	dialog fileFilters: #('*.ston' '*.image').
	self assert: dialog fileFilters equals: {'*.ston, *.image' -> #('*.ston' '*.image')}
]

{ #category : #tests }
FDOpenFileDialogTest >> testExtensions [
	dialog extensionFilters: {'Ext files' -> #(ext)}.
	self assert: dialog fileFilters equals: {'Ext files (*.ext)' -> #('*.ext')}
]

{ #category : #tests }
FDOpenFileDialogTest >> testSelectFile [
	| selectedFile |
	dialog okAction: [ :file | selectedFile := file ].
	window := dialog openDialogWithSpec.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.
	dialog confirm.
	self assert: selectedFile equals: root / 'sth.ext'
]
