"
I'm a column for display the size of the file
"
Class {
	#name : #FDSizeColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDSizeColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 80
]

{ #category : #templateMethod }
FDSizeColumn class >> columnTitle [
	^ 'Size'
]

{ #category : #templateMethod }
FDSizeColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference humanReadableSize
]

{ #category : #sorting }
FDSizeColumn class >> sortValue [
	^ 10
]
