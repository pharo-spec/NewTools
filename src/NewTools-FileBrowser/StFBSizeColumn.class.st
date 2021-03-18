"
I'm a column for display the size of the file in human readable format.
"
Class {
	#name : #StFBSizeColumn,
	#superclass : #StFBAbstractColumn,
	#category : #'NewTools-FileBrowser-Columns'
}

{ #category : #adding }
StFBSizeColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 70
]

{ #category : #templateMethod }
StFBSizeColumn class >> evaluateOn: aFileReference [
	^ aFileReference isDirectory
		ifTrue: [ '--' ]
		ifFalse: [ aFileReference humanReadableSize ]
]

{ #category : #sorting }
StFBSizeColumn class >> priority [
	^ 90
]

{ #category : #templateMethod }
StFBSizeColumn class >> title [
	^ 'Size'
]
