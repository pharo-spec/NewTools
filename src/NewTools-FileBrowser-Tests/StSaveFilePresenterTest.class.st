Class {
	#name : 'StSaveFilePresenterTest',
	#superclass : 'StFilePresenterTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StSaveFilePresenterTest >> dialogClass [

	^ StSaveFilePresenter
]

{ #category : 'tests' }
StSaveFilePresenterTest >> testSelectedEntryAddsTheExtensionOfTheFilter [

	dialog filter: StPNGFilter new.
	dialog nameText: 'photo'.
	self assert: dialog selectedEntry basename equals: 'photo.png'
]

{ #category : 'tests' }
StSaveFilePresenterTest >> testSetNameText [

	| preFillDocName |
	
	preFillDocName := 'mydocument.doc'.
	dialog nameText: preFillDocName.
	self
		assert: dialog nameText
		equals: preFillDocName
]

{ #category : 'tests' }
StSaveFilePresenterTest >> testTitleAndConfirmLabel [

	self assert: dialog windowTitle equals: 'Save As'.
	self assert: dialog confirmLabel equals: 'Save'
]

{ #category : 'tests' }
StSaveFilePresenterTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
