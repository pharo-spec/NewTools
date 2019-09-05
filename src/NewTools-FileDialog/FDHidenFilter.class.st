"
I'm selecting file not hiddenfile
"
Class {
	#name : #FDHidenFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDHidenFilter >> name [
	^ 'filter hidden file'
]

{ #category : #accessing }
FDHidenFilter >> predicate: aFileReference [
	OSPlatform current isWindows
		ifTrue: [ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not.
]
