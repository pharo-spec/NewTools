"
I'm use to creat SpImageTableColumn
"
Class {
	#name : #FDImageTableColumn,
	#superclass : #FDAbstractFileReferenceColumn,
	#category : #'NewTools-FileDialog-Display'
}

{ #category : #testing }
FDImageTableColumn class >> isAbstract [ 
	^ self = FDImageTableColumn
]

{ #category : #class }
FDImageTableColumn class >> tableColumnClass [
	^ SpImageTableColumn
]
