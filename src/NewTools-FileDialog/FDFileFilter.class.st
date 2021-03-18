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

{ #category : #filters }
FDFileFilter >> directoriesOnly: aCollection [
	^ aCollection select: #isDirectory
]

{ #category : #filtering }
FDFileFilter >> files: aCollection matching: patterns [
	^ aCollection select: [ :each | each isDirectory or: [ patterns anySatisfy: [ :pat | pat match: each basename ] ] ]
]

{ #category : #filters }
FDFileFilter >> files: aCollection withExtensions: extensions [
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]
]

{ #category : #accessing }
FDFileFilter >> name [
	^ 'Files'
]

{ #category : #filters }
FDFileFilter >> noHiddenFiles: aCollection [
	^ aCollection reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ]
]

{ #category : #accessing }
FDFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
