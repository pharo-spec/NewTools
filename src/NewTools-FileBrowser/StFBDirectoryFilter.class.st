"
I am a filter that will only select directories. I will reject all the files of the FileDialog.
"
Class {
	#name : #StFBDirectoryFilter,
	#superclass : #StFBAbstractFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBDirectoryFilter class >> priority [
	^ 130
]

{ #category : #accessing }
StFBDirectoryFilter >> name [
	^ 'Folders'
]

{ #category : #accessing }
StFBDirectoryFilter >> predicate: aFileReference [

	^ aFileReference isDirectory and: [ 
		  StFBVisibleFilter new predicate: aFileReference ]
]
