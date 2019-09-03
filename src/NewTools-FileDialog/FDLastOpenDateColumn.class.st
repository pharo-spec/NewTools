"
I'm a column use to display the last access date of a file in a File dialog.
"
Class {
	#name : #FDLastOpenDateColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDLastOpenDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : #templateMethod }
FDLastOpenDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference accessTime fileDialogFormat
]

{ #category : #sorting }
FDLastOpenDateColumn class >> priority [
	^ 70
]

{ #category : #templateMethod }
FDLastOpenDateColumn class >> title [
	^ 'Date Last Opened'
]
