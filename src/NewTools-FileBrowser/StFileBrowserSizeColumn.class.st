"
I'm a column for display the size of the file in human readable format.
"
Class {
	#name : 'StFileBrowserSizeColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserSizeColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 70
]

{ #category : 'templateMethod' }
StFileBrowserSizeColumn class >> evaluateOn: aFileReference [
	^ aFileReference isDirectory
		ifTrue: [ '--' ]
		ifFalse: [ aFileReference humanReadableSize ]
]

{ #category : 'sorting' }
StFileBrowserSizeColumn class >> priority [
	^ 90
]

{ #category : 'templateMethod' }
StFileBrowserSizeColumn class >> title [
	^ 'Size'
]