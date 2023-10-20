"
I am a filter that will select anything (does not reject any item).
"
Class {
	#name : 'StFBAllFilter',
	#superclass : 'StFBAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBAllFilter class >> priority [
	^ 150
]

{ #category : 'accessing' }
StFBAllFilter >> name [
	^ 'All'
]

{ #category : 'accessing' }
StFBAllFilter >> predicate: aFileReference [
	^ true
]
