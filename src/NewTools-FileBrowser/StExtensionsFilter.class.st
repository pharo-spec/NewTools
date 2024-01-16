"
I am an abstract filter which subclasses define filtering depending on the extension of the file.

My subclasses should define a basename for the filter and a collection of extensions to select.

Public API and Key Messages
--------------------

- #basename 		Return the name of the filter. The displayed name will be this basename + the list of extensions accepted by the filter.
- #extensions 	Return the collection of extensions we should keep with this filter.
"
Class {
	#name : 'StExtensionsFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StExtensionsFilter class >> isAbstract [
	^ self = StExtensionsFilter
]

{ #category : 'accessing' }
StExtensionsFilter class >> priority [
	^ 50
]

{ #category : 'comparing' }
StExtensionsFilter >> = aComparable [

	"Double dispatch"

	^ aComparable equalsToExtensionFilter: self
]

{ #category : 'adding' }
StExtensionsFilter >> addExtensionTo: aFileReference [

	(self predicate: aFileReference) ifTrue: [ ^ aFileReference ].
	self extensions ifEmpty: [ ^ aFileReference ].
	^ aFileReference , (self extensions first copyWithout: $.)
]

{ #category : 'accessing' }
StExtensionsFilter >> basename [
	^ self subclassResponsibility
]

{ #category : 'comparing' }
StExtensionsFilter >> equalsToExtensionFilter: aExtensionFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self extensions asSet = aExtensionFilter extensions asSet
]

{ #category : 'accessing' }
StExtensionsFilter >> extensions [
	"Should return sequenceable collection of extensions"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
StExtensionsFilter >> extensionsWithDots [

	^ self extensions collect: [ :each | 
		  each first = $.
			  ifTrue: [ each ]
			  ifFalse: [ '.' , each ] ]
]

{ #category : 'comparing' }
StExtensionsFilter >> hash [

	"Hash must be redefined whenever = is redefined."

	^ self extensionsWithDots hash
]

{ #category : 'accessing' }
StExtensionsFilter >> name [
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
StExtensionsFilter >> predicate: aFileReference [

	aFileReference isDirectory ifTrue: [ ^ true ].

	^ (self extensionsWithDots anySatisfy: [ :extension | 
		   aFileReference basename asLowercase endsWith: extension ]) and: [ 
		  StVisibleFilter new predicate: aFileReference ]
]
