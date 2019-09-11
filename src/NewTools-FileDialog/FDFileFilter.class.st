"
I am a filter that will only select files. I will reject all the directories of the FileDialog.
"
Class {
	#name : #FDFileFilter,
	#superclass : #FDAbstractFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDFileFilter class >> priority [
	^ 130
]

{ #category : #accessing }
FDFileFilter >> name [
	^ 'Files'
]

{ #category : #accessing }
FDFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
