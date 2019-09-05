"
I'm a column use to displayan icon depending on the file to display in the file dialog.
"
Class {
	#name : #FDIconColumn,
	#superclass : #FDAbstractColumn,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDIconColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 20
]

{ #category : #templateMethod }
FDIconColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference isDirectory ifTrue: [ self iconNamed: #configNew ] ifFalse: [ self iconNamed: #page ]
]

{ #category : #sorting }
FDIconColumn class >> priority [
	^ 0
]

{ #category : #class }
FDIconColumn class >> tableColumnClass [
	^ SpImageTableColumn
]

{ #category : #templateMethod }
FDIconColumn class >> title [
	^ ''
]
