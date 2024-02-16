"
I'm a column use to display the modification date of a file in a File dialog.
"
Class {
	#name : 'StFileBrowserModificationDateColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserModificationDateColumn class >> addConstraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : 'templateMethod' }
StFileBrowserModificationDateColumn class >> evaluateOn: aFileReference [

	^ [ aFileReference modificationTime fileDialogFormat ]
		  on: Error
		  do: [ 'N/A' ]
]

{ #category : 'sorting' }
StFileBrowserModificationDateColumn class >> priority [
	^ 50
]

{ #category : 'templateMethod' }
StFileBrowserModificationDateColumn class >> title [
	^ 'Date Modified'
]
