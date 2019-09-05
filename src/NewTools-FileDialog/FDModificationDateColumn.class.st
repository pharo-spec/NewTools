"
I'm a column use to display the modification date of a file in a File dialog.
"
Class {
	#name : #FDModificationDateColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDModificationDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : #templateMethod }
FDModificationDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference modificationTime fileDialogFormat
]

{ #category : #sorting }
FDModificationDateColumn class >> priority [
	^ 50
]

{ #category : #templateMethod }
FDModificationDateColumn class >> title [
	^ 'Date Modified'
]
