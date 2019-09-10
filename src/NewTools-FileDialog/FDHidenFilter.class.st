"
I am a filter that will only select visible files. I will reject all the hidden files of the FileDialog.
"
Class {
	#name : #FDHidenFilter,
	#superclass : #FDAbstractFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDHidenFilter class >> priority [
	^ 100
]

{ #category : #accessing }
FDHidenFilter >> name [
	^ 'Non hidden'
]

{ #category : #accessing }
FDHidenFilter >> predicate: aFileReference [
	OSPlatform current isWindows ifTrue: [ ^ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not
]
