"
I'm use to give you the name of a fileReference.

For example for the file 'my/path/something.exe' I'll display something.exe.
"
Class {
	#name : #StFBNameColumn,
	#superclass : #StFBAbstractColumn,
	#category : #'NewTools-FileBrowser-Columns'
}

{ #category : #adding }
StFBNameColumn class >> addContraintTo: aTableColumn [
	"do nothing"
]

{ #category : #templateMethod }
StFBNameColumn class >> evaluateOn: aFileReference [

	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : #sorting }
StFBNameColumn class >> priority [
	^ 1
]

{ #category : #templateMethod }
StFBNameColumn class >> title [
	^ 'Name'
]
