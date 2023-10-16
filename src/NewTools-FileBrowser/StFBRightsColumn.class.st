"
I'm a column use to give you the access rights of a FileReference
"
Class {
	#name : 'StFBRightsColumn',
	#superclass : 'StFBAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFBRightsColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 110
]

{ #category : 'templateMethod' }
StFBRightsColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference permissions
]

{ #category : 'sorting' }
StFBRightsColumn class >> priority [
	^ 100
]

{ #category : 'templateMethod' }
StFBRightsColumn class >> title [
	^ 'Rights'
]
