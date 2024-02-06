"
I am a filter that will only select files. I will reject all the directories of the FileDialog.
"
Class {
	#name : 'StFileFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFileFilter class >> priority [
	^ 130
]

{ #category : 'filters' }
StFileFilter >> directoriesOnly: aCollection [
	^ aCollection select: #isDirectory
]

{ #category : 'filtering' }
StFileFilter >> files: aCollection matching: patterns [
	^ aCollection select: [ :each | each isDirectory or: [ patterns anySatisfy: [ :pat | pat match: each basename ] ] ]
]

{ #category : 'filters' }
StFileFilter >> files: aCollection withExtensions: extensions [
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]
]

{ #category : 'accessing' }
StFileFilter >> name [
	^ 'Files'
]

{ #category : 'filters' }
StFileFilter >> noHiddenFiles: aCollection [
	^ aCollection reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ]
]

{ #category : 'accessing' }
StFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
