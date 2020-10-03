Class {
	#name : #StVariableTagColumn,
	#superclass : #SpTableColumn,
	#instVars : [
		'action',
		'table'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StVariableTagColumn class >> on: aStRawInspection [
	^self new rawInspection: aStRawInspection 
]

{ #category : #visiting }
StVariableTagColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitVariableTagColumn: self
]

{ #category : #filtering }
StVariableTagColumn >> applyFilterFrom: aVariableTag [
	table toggleFilter: aVariableTag 
]

{ #category : #filtering }
StVariableTagColumn >> hasActiveFilter [
	^ table hasActiveFilter
]

{ #category : #accessing }
StVariableTagColumn >> rawInspection: aRawInspection [

	table := aRawInspection
]
