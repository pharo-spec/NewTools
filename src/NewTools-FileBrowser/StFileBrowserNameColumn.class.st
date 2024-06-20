"
I'm use to give you the name of a fileReference.

For example for the file 'my/path/something.exe' I'll display something.exe.
"
Class {
	#name : 'StFileBrowserNameColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserNameColumn class >> addConstraintTo: aTableColumn [

	aTableColumn beSortable
]

{ #category : 'templateMethod' }
StFileBrowserNameColumn class >> evaluateOn: aFileReference [

	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : 'sorting' }
StFileBrowserNameColumn class >> priority [
	^ 1
]

{ #category : 'templateMethod' }
StFileBrowserNameColumn class >> title [
	^ 'Name'
]
