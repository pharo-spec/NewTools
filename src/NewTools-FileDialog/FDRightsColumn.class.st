"
I'm a column use to give you the access right of a FileReference
"
Class {
	#name : #FDRightsColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDRightsColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 120
]

{ #category : #templateMethod }
FDRightsColumn class >> columnTitle [
	^ 'Rights'
]

{ #category : #templateMethod }
FDRightsColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference permissions
]

{ #category : #sorting }
FDRightsColumn class >> sortValue [
	^ 50
]
