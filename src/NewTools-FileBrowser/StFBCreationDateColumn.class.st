"
I'm a column use to display the creation date of a file in a File dialog.
"
Class {
	#name : 'StFBCreationDateColumn',
	#superclass : 'StFBAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFBCreationDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : 'templateMethod' }
StFBCreationDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference creationTime fileDialogFormat
]

{ #category : 'sorting' }
StFBCreationDateColumn class >> priority [
	^ 60
]

{ #category : 'templateMethod' }
StFBCreationDateColumn class >> title [
	^ 'Date Created'
]
