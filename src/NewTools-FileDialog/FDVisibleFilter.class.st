"
I am a filter that will only select visible files. I will reject all the hidden files of the FileDialog.
"
Class {
	#name : #FDVisibleFilter,
	#superclass : #FDAbstractFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDVisibleFilter class >> priority [
	^ 100
]

{ #category : #accessing }
FDVisibleFilter >> name [
	^ 'Non hidden'
]

{ #category : #accessing }
FDVisibleFilter >> predicate: aFileReference [
	OSPlatform current isWindows ifTrue: [ ^ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not
]
