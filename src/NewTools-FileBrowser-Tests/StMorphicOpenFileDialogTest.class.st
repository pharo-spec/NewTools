Class {
	#name : 'StMorphicOpenFileDialogTest',
	#superclass : 'TestCase',
	#instVars : [
		'backend'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
StMorphicOpenFileDialogTest >> setUp [

	super setUp.
	backend := StTestFileDialogMorphicBackend new
]

{ #category : 'tests' }
StMorphicOpenFileDialogTest >> testCancelledDialogAnswersNil [

	backend dialogResult: nil.

	self assert: (backend executeOpenFileDialog: SpFileDialog new) isNil
]

{ #category : 'tests' }
StMorphicOpenFileDialogTest >> testChosenFileIsAnswered [

	| file |
	file := FileSystem memory / 'foo.txt'.
	backend dialogResult: { file }.

	self assert: (backend executeOpenFileDialog: SpFileDialog new) equals: file
]
