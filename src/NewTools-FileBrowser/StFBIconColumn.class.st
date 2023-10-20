"
I'm a column use to displayan icon depending on the file to display in the file dialog.
"
Class {
	#name : 'StFBIconColumn',
	#superclass : 'StFBAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFBIconColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 20
]

{ #category : 'templateMethod' }
StFBIconColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference isDirectory ifTrue: [ self iconNamed: #configNew ] ifFalse: [ self iconNamed: #page ]
]

{ #category : 'sorting' }
StFBIconColumn class >> priority [
	^ 0
]

{ #category : 'class' }
StFBIconColumn class >> tableColumnClass [
	^ SpImageTableColumn
]

{ #category : 'templateMethod' }
StFBIconColumn class >> title [
	^ ''
]
