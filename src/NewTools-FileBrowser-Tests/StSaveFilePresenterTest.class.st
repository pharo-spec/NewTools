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
StSaveFilePresenterTest >> testSetNameText [

	| preFillDocName |
	
	preFillDocName := 'mydocument.doc'.
	dialog nameText: preFillDocName.
	self
		assert: dialog nameText
		equals: preFillDocName
]

{ #category : 'tests' }
StSaveFilePresenterTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog fileReferenceTable items includesAll: newDirectory children)
]
