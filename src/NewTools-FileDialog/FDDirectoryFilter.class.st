"
I'm selecting only directory
"
Class {
	#name : #FDDirectoryFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDDirectoryFilter >> name [
	^ 'directory filter'
]

{ #category : #accessing }
FDDirectoryFilter >> predicate: aFileReference [
	^ aFileReference isDirectory
]
