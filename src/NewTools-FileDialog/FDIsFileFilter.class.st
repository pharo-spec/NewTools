"
I'm selecting file
"
Class {
	#name : #FDIsFileFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDIsFileFilter >> name [
	^ 'file filter'
]

{ #category : #accessing }
FDIsFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
