"
I'm use to give you an Icon 
	
"
Class {
	#name : #FDIconColumn,
	#superclass : #FDImageTableColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #adding }
FDIconColumn class >> addContraintTo: aTableColumn [
	aTableColumn width: 20
]

{ #category : #templateMethod }
FDIconColumn class >> columnTitle [
	^ ''
]

{ #category : #templateMethod }
FDIconColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference isDirectory ifTrue: [ self iconNamed: #configNew ] ifFalse: [ self iconNamed: #page ]
]

{ #category : #sorting }
FDIconColumn class >> sortValue [
	^ 0
]
