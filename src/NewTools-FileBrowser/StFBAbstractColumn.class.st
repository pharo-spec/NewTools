"
I am an abstract class representing a possible column of the file dialog. 

Public API and Key Messages
--------------------

My subclasses will each represent a concrete column and define:
- Their title
- How to display the content of the column from a file references
- Optionally, how to customize the column
"
Class {
	#name : #StFBAbstractColumn,
	#superclass : #Object,
	#category : #'NewTools-FileBrowser-Columns'
}

{ #category : #adding }
StFBAbstractColumn class >> addContraintTo: aTableColumn [
	"I'm use to add option to column like width ... 
	look at class 
		SpTableColumn"
	self subclassResponsibility
]

{ #category : #accessing }
StFBAbstractColumn class >> column [
	"I'm returning a SpTreeTableColumn"

	| column |
	column := self tableColumnClass title: self title evaluated: self contentValuable.
	self addContraintTo: column.
	^ column
]

{ #category : #accessing }
StFBAbstractColumn class >> columns [
	^ ((self allSubclasses reject: #isAbstract) sort: #priority ascending) collect: #column
]

{ #category : #templateMethod }
StFBAbstractColumn class >> contentValuable [
	^ [ :selectedFileReference | self evaluateOn: selectedFileReference ]
]

{ #category : #templateMethod }
StFBAbstractColumn class >> evaluateOn: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : #testing }
StFBAbstractColumn class >> isAbstract [ 
	^ self = StFBAbstractColumn
]

{ #category : #sorting }
StFBAbstractColumn class >> priority [
	^ self subclassResponsibility
]

{ #category : #class }
StFBAbstractColumn class >> tableColumnClass [
	^ SpStringTableColumn
]

{ #category : #templateMethod }
StFBAbstractColumn class >> title [
	"I'm returning a String"
	^ self subclassResponsibility
]
