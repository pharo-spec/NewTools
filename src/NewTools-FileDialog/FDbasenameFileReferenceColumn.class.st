"
I'm use to give you the basename of a fileReference
	example : 'my/path/something.exe' asFileReference basename >> something.exe 
"
Class {
	#name : #FDBasenameFileReferenceColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDBasenameFileReferenceColumn class >> addContraintTo: aTableColumn [
	"do nothing"
]

{ #category : #templateMethod }
FDBasenameFileReferenceColumn class >> columnTitle [
	"I'm returning a String for the title"

	^ 'basename'
]

{ #category : #templateMethod }
FDBasenameFileReferenceColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : #sorting }
FDBasenameFileReferenceColumn class >> sortValue [
	^ 1
]
