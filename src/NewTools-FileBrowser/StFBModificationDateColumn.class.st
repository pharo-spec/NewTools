"
I'm a column use to display the modification date of a file in a File dialog.
"
Class {
	#name : #StFBModificationDateColumn,
	#superclass : #StFBAbstractColumn,
	#category : #'NewTools-FileBrowser-Columns'
}

{ #category : #adding }
StFBModificationDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : #templateMethod }
StFBModificationDateColumn class >> evaluateOn: aFileReference [

	^ aFileReference modificationTime fileDialogFormat
]

{ #category : #sorting }
StFBModificationDateColumn class >> priority [
	^ 50
]

{ #category : #templateMethod }
StFBModificationDateColumn class >> title [
	^ 'Date Modified'
]
