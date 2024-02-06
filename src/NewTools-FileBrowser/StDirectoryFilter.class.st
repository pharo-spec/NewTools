"
I am a filter that will only select directories. I will reject all the files of the FileDialog.
"
Class {
	#name : 'StDirectoryFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StDirectoryFilter class >> priority [
	^ 130
]

{ #category : 'accessing' }
StDirectoryFilter >> name [
	^ 'Folders'
]

{ #category : 'accessing' }
StDirectoryFilter >> predicate: aFileReference [

	^ aFileReference isDirectory
]
