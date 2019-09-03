"
I'm a column for display the size of the file in human readable format.
"
Class {
	#name : #FDSizeColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDSizeColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 70
]

{ #category : #templateMethod }
FDSizeColumn class >> evaluateOn: aFileReference [
	^ aFileReference isDirectory
		ifTrue: [ '--' ]
		ifFalse: [ aFileReference humanReadableSize ]
]

{ #category : #sorting }
FDSizeColumn class >> priority [
	^ 90
]

{ #category : #templateMethod }
FDSizeColumn class >> title [
	^ 'Size'
]
