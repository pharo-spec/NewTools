"
I'm a column use to display the last access date of a file in a File dialog.
"
Class {
	#name : 'StFBLastOpenDateColumn',
	#superclass : 'StFBAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFBLastOpenDateColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 150
]

{ #category : 'templateMethod' }
StFBLastOpenDateColumn class >> evaluateOn: aFileReference [
	^ aFileReference accessTime fileDialogFormat
]

{ #category : 'sorting' }
StFBLastOpenDateColumn class >> priority [
	^ 70
]

{ #category : 'templateMethod' }
StFBLastOpenDateColumn class >> title [
	^ 'Date Last Opened'
]
