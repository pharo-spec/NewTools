"
I'm a column use to display the creation date of a file in a File dialog.
"
Class {
	#name : #FDCreationDateColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDCreationDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : #templateMethod }
FDCreationDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference creationTime fileDialogFormat
]

{ #category : #sorting }
FDCreationDateColumn class >> priority [
	^ 60
]

{ #category : #templateMethod }
FDCreationDateColumn class >> title [
	^ 'Date Created'
]
