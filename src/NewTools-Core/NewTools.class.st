Class {
	#name : #NewTools,
	#superclass : #Object,
	#category : #'NewTools-Core'
}

{ #category : #'world menu' }
NewTools class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'New Tools') order: 20
]
