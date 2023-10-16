"
I am an abstract filter which subclasses define filtering depending on the extension of the file.

My subclasses should define a basename for the filter and a collection of extensions to select.

Public API and Key Messages
--------------------

- #basename 		Return the name of the filter. The displayed name will be this basename + the list of extensions accepted by the filter.
- #extensions 	Return the collection of extensions we should keep with this filter.
"
Class {
	#name : 'StFBExtensionsFilter',
	#superclass : 'StFBAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StFBExtensionsFilter class >> isAbstract [
	^ self = StFBExtensionsFilter
]

{ #category : 'accessing' }
StFBExtensionsFilter class >> priority [
	^ 50
]

{ #category : 'comparing' }
StFBExtensionsFilter >> = aComparable [

	"Double dispatch"

	^ aComparable equalsToExtensionFilter: self
]

{ #category : 'adding' }
StFBExtensionsFilter >> addExtensionTo: aFileReference [

	(self predicate: aFileReference) ifTrue: [ ^ aFileReference ].
	self extensions ifEmpty: [ ^ aFileReference ].
	^ aFileReference , (self extensions first copyWithout: $.)
]

{ #category : 'accessing' }
StFBExtensionsFilter >> basename [
	^ self subclassResponsibility
]

{ #category : 'comparing' }
StFBExtensionsFilter >> equalsToExtensionFilter: aExtensionFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self extensions asSet = aExtensionFilter extensions asSet
]

{ #category : 'accessing' }
StFBExtensionsFilter >> extensions [
	"Should return sequenceable collection of extensions"

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
StFBExtensionsFilter >> extensionsWithDots [

	^ self extensions collect: [ :each | 
		  each first = $.
			  ifTrue: [ each ]
			  ifFalse: [ '.' , each ] ]
]

{ #category : 'comparing' }
StFBExtensionsFilter >> hash [

	"Hash must be redefined whenever = is redefined."

	^ self extensionsWithDots hash
]

{ #category : 'accessing' }
StFBExtensionsFilter >> name [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: self basename;
				space;
				nextPut: $(.
			self extensionsWithDots
				do: [ :ext | 
					s
						nextPut: $*;
						nextPutAll: ext ]
				separatedBy: [ s nextPut: $, ].
			s nextPut: $) ]
]

{ #category : 'accessing' }
StFBExtensionsFilter >> predicate: aFileReference [

	aFileReference isDirectory ifTrue: [ ^ true ].

	^ (self extensionsWithDots anySatisfy: [ :extension | 
		   aFileReference basename asLowercase endsWith: extension ]) and: [ 
		  StFBVisibleFilter new predicate: aFileReference ]
]
