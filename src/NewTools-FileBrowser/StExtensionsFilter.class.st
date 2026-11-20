"
I am the abstract root of the filters that keep files according to their extension. `StFileBrowserAbstractFilter` describes how filters are created and used; I add the extension matching, the displayed name, and the completion of file names for the save dialog.

My subclasses `StPNGFilter`, `StJPEGFilter`, `StGIFFilter` and `StBitmapFilter` are default filters; `StCustomExtensionsFilter` is built from the extensions given to a dialog.

## Responsibility:

- Keep the directories, so the user can still navigate, and the files whose name ends with one of my extensions, ignoring case.
- Build the displayed name from the basename and the extensions, e.g. 'JPEG (*.jpg,*.jpeg,*.jpe,*.jfif)'.
- Complete a file name with my first extension when it does not have one of mine.

## Collaborators:

- `StSaveFilePresenter`: asks me to complete the typed file name (`addExtensionTo:`).

## Public API and Key Messages

- `extensions`: the extensions I keep, with or without the leading dot. Subclasses define it.
- `basename`: the first part of my name. Subclasses define it.
- `addExtensionTo: aFileReference`: answers the reference itself when I accept it, otherwise the reference with my first extension appended.

## Examples

```smalltalk
StExtensionsFilter scriptImageFilters.
```

It shows, for each image filter, whether it accepts 'photo.JPG' and how it completes the name 'photo'.

### Implementation Points

Two extension filters are equal when they have the same set of extensions, whatever their class; `hash` follows the extensions. So a `StCustomExtensionsFilter` on `#( 'png' )` given to a dialog is not added to the drop list: `defaultFiltersWith:` keeps the equal `StPNGFilter`, which gets selected.
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

{ #category : 'script' }
StExtensionsFilter class >> scriptImageFilters [
	"Shows, for each image filter, whether it accepts 'photo.JPG' and how it completes the name 'photo' with its first extension, as the save dialog does."

	<example>
	| filters |
	filters := {
		           StPNGFilter new.
		           StJPEGFilter new.
		           StGIFFilter new.
		           StBitmapFilter new }.
	(filters collect: [ :filter |
			 filter name -> {
				 (filter predicate: 'photo.JPG' asFileReference).
				 (filter addExtensionTo: 'photo' asFileReference) basename } ]) inspect
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

	^ self extensionsWithDots anySatisfy: [ :extension |
		  aFileReference basename asLowercase endsWith: extension ]
]
