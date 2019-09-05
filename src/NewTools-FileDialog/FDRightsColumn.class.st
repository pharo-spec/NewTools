"
I'm a column use to give you the access rights of a FileReference
"
Class {
	#name : #FDRightsColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDRightsColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 110
]

{ #category : #templateMethod }
FDRightsColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference permissions
]

{ #category : #sorting }
FDRightsColumn class >> priority [
	^ 100
]

{ #category : #templateMethod }
FDRightsColumn class >> title [
	^ 'Rights'
]
