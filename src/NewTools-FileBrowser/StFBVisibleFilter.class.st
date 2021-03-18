"
I am a filter that will only select visible files. I will reject all the hidden files of the FileDialog.
"
Class {
	#name : #StFBVisibleFilter,
	#superclass : #StFBAbstractFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBVisibleFilter class >> priority [
	^ 100
]

{ #category : #accessing }
StFBVisibleFilter >> name [
	^ 'Non hidden'
]

{ #category : #accessing }
StFBVisibleFilter >> predicate: aFileReference [
	OSPlatform current isWindows ifTrue: [ ^ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not
]
