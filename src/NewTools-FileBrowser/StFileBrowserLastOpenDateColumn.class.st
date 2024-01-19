"
I'm a column use to display the last access date of a file in a File dialog.
"
Class {
	#name : 'StFileBrowserLastOpenDateColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserLastOpenDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : 'templateMethod' }
StFileBrowserLastOpenDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference accessTime fileDialogFormat
]

{ #category : 'sorting' }
StFileBrowserLastOpenDateColumn class >> priority [
	^ 70
]

{ #category : 'templateMethod' }
StFileBrowserLastOpenDateColumn class >> title [
	^ 'Date Last Opened'
]
