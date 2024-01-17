"
I am an abstract class. My subclasses are used to filter a file dialog table. 

My subclasses will for example filter a list to display only the folder, or only the files ending with a certain extension.

Public API and Key Messages
--------------------

- #predicat: 		Should answer true if the FileReference as parameter should be displayed, or false if it shouldn't.
- #name				Return the name of the filter.

"
Class {
	#name : 'StFileBrowserAbstractFilter',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StFileBrowserAbstractFilter class >> canBeDefault [
	^ self isAbstract not
]

{ #category : 'actions' }
StFileBrowserAbstractFilter class >> defaultFilters [

	^ ((self allSubclasses select: #canBeDefault) sorted:
		   #priority descending) collect: #new
]

{ #category : 'actions' }
StFileBrowserAbstractFilter class >> defaultFiltersWith: aFilter [

	| defaultFilters |
	defaultFilters := self defaultFilters.
	(defaultFilters includes: aFilter) ifTrue: [ ^ defaultFilters ].
	^ { aFilter } , self defaultFilters
]

{ #category : 'testing' }
StFileBrowserAbstractFilter class >> isAbstract [
	^ self = StFileBrowserAbstractFilter
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter class >> priority [
	^ 1
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> < aComparable [

	"Answer whether the receiver is less than the argument."

	^ self class priority < aComparable class priority
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> = aComparable [

	"Double dispatch"

	^ aComparable equalsToNonExtensionFilter: self
]

{ #category : 'adding' }
StFileBrowserAbstractFilter >> addExtensionTo: aFileReference [

	^ aFileReference
]

{ #category : 'applying' }
StFileBrowserAbstractFilter >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference select: [ :eachFileReference | self predicate: eachFileReference ]
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> equalsToExtensionFilter: aExtensionFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self class = aExtensionFilter class
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> equalsToNonExtensionFilter: aFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self class = aFilter class
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> hash [

	"Hash must be redefined whenever = is redefined."

	^ self class priority
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter >> name [
	"Name of the filter to display in the UI."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter >> predicate: aFileReference [
	"I should answer true if the filter should display the file reference as parameter and false if it should filter it."

	^ self subclassResponsibility
]
