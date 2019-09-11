"
I am a filter that will only select directories. I will reject all the files of the FileDialog.
"
Class {
	#name : #FDDirectoryFilter,
	#superclass : #FDAbstractFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDDirectoryFilter class >> priority [
	^ 130
]

{ #category : #accessing }
FDDirectoryFilter >> name [
	^ 'Folders'
]

{ #category : #accessing }
FDDirectoryFilter >> predicate: aFileReference [
	^ aFileReference isDirectory
]
