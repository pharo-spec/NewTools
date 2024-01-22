"
I am a filter that will only select visible files. I will reject all the hidden files of the FileDialog.
"
Class {
	#name : 'StVisibleFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StVisibleFilter class >> priority [
	^ 50
]

{ #category : 'accessing' }
StVisibleFilter >> name [
	^ 'Without hidden'
]

{ #category : 'accessing' }
StVisibleFilter >> predicate: aFileReference [
	 
	^ aFileReference isHidden not
]
