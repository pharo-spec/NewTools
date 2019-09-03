"
I'm use to give you the basename of a fileReference
	example : 'my/path/something.exe' asFileReference basename >> something.exe 
"
Class {
	#name : #FDNameColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDNameColumn class >> addContraintTo: aTableColumn [
	"do nothing"
]

{ #category : #templateMethod }
FDNameColumn class >> columnTitle [
	^ 'Name'
]

{ #category : #templateMethod }
FDNameColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : #sorting }
FDNameColumn class >> sortValue [
	^ 1
]
