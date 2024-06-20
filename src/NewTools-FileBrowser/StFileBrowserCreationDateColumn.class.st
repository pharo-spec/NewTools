"
I'm a column use to display the creation date of a file in a File dialog.
"
Class {
	#name : 'StFileBrowserCreationDateColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserCreationDateColumn class >> addConstraintTo: aTableColumn [

	aTableColumn
		width: 150;
		beSortable
]

{ #category : 'templateMethod' }
StFileBrowserCreationDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference creationTime fileDialogFormat
]

{ #category : 'sorting' }
StFileBrowserCreationDateColumn class >> priority [
	^ 60
]

{ #category : 'templateMethod' }
StFileBrowserCreationDateColumn class >> title [
	^ 'Date Created'
]
