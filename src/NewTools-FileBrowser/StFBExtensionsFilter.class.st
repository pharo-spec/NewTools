"
I am an abstract filter which subclasses define filtering depending on the extension of the file.

My subclasses should define a basename for the filter and a collection of extensions to select.

Public API and Key Messages
--------------------

- #basename 		Return the name of the filter. The displayed name will be this basename + the list of extensions accepted by the filter.
- #extensions 	Return the collection of extensions we should keep with this filter.
"
Class {
	#name : #StFBExtensionsFilter,
	#superclass : #StFBAbstractFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #testing }
StFBExtensionsFilter class >> isAbstract [
	^ self = StFBExtensionsFilter
]

{ #category : #accessing }
StFBExtensionsFilter class >> priority [
	^ 50
]

{ #category : #accessing }
StFBExtensionsFilter >> basename [
	^ self subclassResponsibility
]

{ #category : #accessing }
StFBExtensionsFilter >> extensions [
	^ self subclassResponsibility
]

{ #category : #accessing }
StFBExtensionsFilter >> name [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: self basename;
				space;
				nextPut: $(.
			self extensions
				do: [ :ext | 
					s
						nextPut: $*;
						nextPutAll: ext ]
				separatedBy: [ s nextPut: $, ].
			s nextPut: $) ]
]

{ #category : #accessing }
StFBExtensionsFilter >> predicate: aFileReference [
	aFileReference isDirectory ifTrue: [ ^ true ].

	^ self extensions
		detect: [ :extension | aFileReference basename asLowercase endsWith: extension ]
		ifFound: [ :ext | true ]
		ifNone: [ false ]
]
