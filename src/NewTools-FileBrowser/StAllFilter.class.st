"
I am a filter that will select anything (does not reject any item).
"
Class {
	#name : 'StAllFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StAllFilter class >> priority [
	^ 150
]

{ #category : 'accessing' }
StAllFilter >> name [
	^ 'All'
]

{ #category : 'accessing' }
StAllFilter >> predicate: aFileReference [
	^ true
]
