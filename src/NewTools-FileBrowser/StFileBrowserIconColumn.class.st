"
I'm a column use to displayan icon depending on the file to display in the file dialog.
"
Class {
	#name : 'StFileBrowserIconColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserIconColumn class >> addConstraintTo: aTableColumn [
	aTableColumn width: 20
]

{ #category : 'templateMethod' }
StFileBrowserIconColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference isDirectory ifTrue: [ self iconNamed: #configNew ] ifFalse: [ self iconNamed: #page ]
]

{ #category : 'sorting' }
StFileBrowserIconColumn class >> priority [
	^ 0
]

{ #category : 'class' }
StFileBrowserIconColumn class >> tableColumnClass [
	^ SpImageTableColumn
]

{ #category : 'templateMethod' }
StFileBrowserIconColumn class >> title [
	^ ''
]
