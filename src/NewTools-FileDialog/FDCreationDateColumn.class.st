"
I'm a column use to display the creation date of a file
"
Class {
	#name : #FDCreationDateColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDCreationDateColumn class >> addContraintTo: aTableColumn [
	"do nothing"
]

{ #category : #templateMethod }
FDCreationDateColumn class >> columnTitle [
	^ 'Creation date'
]

{ #category : #templateMethod }
FDCreationDateColumn class >> evaluateOn: aFileReference [ 
	^ aFileReference creationTime asString
]

{ #category : #sorting }
FDCreationDateColumn class >> sortValue [
	^ 100
]
