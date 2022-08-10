"
I am a filter that will only select files. I will reject all the directories of the FileDialog.
"
Class {
	#name : #StFBFileFilter,
	#superclass : #StFBAbstractFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBFileFilter class >> priority [
	^ 130
]

{ #category : #filters }
StFBFileFilter >> directoriesOnly: aCollection [
	^ aCollection select: #isDirectory
]

{ #category : #filtering }
StFBFileFilter >> files: aCollection matching: patterns [
	^ aCollection select: [ :each | each isDirectory or: [ patterns anySatisfy: [ :pat | pat match: each basename ] ] ]
]

{ #category : #filters }
StFBFileFilter >> files: aCollection withExtensions: extensions [
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]
]

{ #category : #accessing }
StFBFileFilter >> name [
	^ 'Files'
]

{ #category : #filters }
StFBFileFilter >> noHiddenFiles: aCollection [
	^ aCollection reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ]
]

{ #category : #accessing }
StFBFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
