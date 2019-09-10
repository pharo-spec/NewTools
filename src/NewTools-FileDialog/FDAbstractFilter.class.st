"
I am an abstract class. My subclasses are used to filter a file dialog table. 

My subclasses will for example filter a list to display only the folder, or only the files ending with a certain extension.

Public API and Key Messages
--------------------

- #predicat: 		Should answer true if the FileReference as parameter should be displayed, or false if it shouldn't.
- #name				Return the name of the filter.

"
Class {
	#name : #FDAbstractFilter,
	#superclass : #Object,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #actions }
FDAbstractFilter class >> defaultFilters [
	^ ((self allSubclasses reject: #isAbstract) sorted: #priority descending) collect: #new
]

{ #category : #testing }
FDAbstractFilter class >> isAbstract [
	^ self = FDAbstractFilter
]

{ #category : #accessing }
FDAbstractFilter class >> priority [
	^ 1
]

{ #category : #applying }
FDAbstractFilter >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference select: [ :eachFileReference | self predicate: eachFileReference ]
]

{ #category : #comparing }
FDAbstractFilter >> equals: aPredicate [
	self flag: #todo. "We should have a real #= method..."
	^ self className = aPredicate className
]

{ #category : #accessing }
FDAbstractFilter >> name [
	"Name of the filter to display in the UI."

	^ self subclassResponsibility
]

{ #category : #accessing }
FDAbstractFilter >> predicate: aFileReference [
	"I should answer true if the filter should display the file reference as parameter and false if it should filter it."

	^ self subclassResponsibility
]
