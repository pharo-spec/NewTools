"
I'm a column use to give you the access rights of a FileReference
"
Class {
	#name : 'StFileBrowserRightsColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserRightsColumn class >> addConstraintTo: aTableColumn [
	aTableColumn width: 110
]

{ #category : 'templateMethod' }
StFileBrowserRightsColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference permissions
]

{ #category : 'sorting' }
StFileBrowserRightsColumn class >> priority [
	^ 100
]

{ #category : 'templateMethod' }
StFileBrowserRightsColumn class >> title [
	^ 'Rights'
]
