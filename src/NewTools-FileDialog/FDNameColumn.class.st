"
I'm use to give you the name of a fileReference.

For example for the file 'my/path/something.exe' I'll display something.exe.
"
Class {
	#name : #FDNameColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDNameColumn class >> addContraintTo: aTableColumn [
	"do nothing"
]

{ #category : #templateMethod }
FDNameColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : #sorting }
FDNameColumn class >> priority [
	^ 1
]

{ #category : #templateMethod }
FDNameColumn class >> title [
	^ 'Name'
]
