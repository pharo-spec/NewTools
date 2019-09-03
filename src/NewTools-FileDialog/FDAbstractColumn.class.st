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
	#name : #FDAbstractColumn,
	#superclass : #Object,
	#category : #'NewTools-FileDialog-Columns'
}

{ #category : #adding }
FDAbstractColumn class >> addContraintTo: aTableColumn [
	"I'm use to add option to column like width ... 
	look at class 
		SpTableColumn"
	self subclassResponsibility
]

{ #category : #accessing }
FDAbstractColumn class >> column [
	"I'm returning a SpTreeTableColumn"

	| column |
	column := self tableColumnClass title: self title evaluated: self contentValuable.
	self addContraintTo: column.
	^ column
]

{ #category : #accessing }
FDAbstractColumn class >> columns [
	^ ((self allSubclasses reject: #isAbstract) sort: #priority ascending) collect: #column
]

{ #category : #templateMethod }
FDAbstractColumn class >> contentValuable [
	^ [ :selectedFileReference | self evaluateOn: selectedFileReference ]
]

{ #category : #templateMethod }
FDAbstractColumn class >> evaluateOn: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : #testing }
FDAbstractColumn class >> isAbstract [ 
	^ self = FDAbstractColumn
]

{ #category : #sorting }
FDAbstractColumn class >> priority [
	^ self subclassResponsibility
]

{ #category : #class }
FDAbstractColumn class >> tableColumnClass [
	^ SpStringTableColumn
]

{ #category : #templateMethod }
FDAbstractColumn class >> title [
	"I'm returning a String"
	^ self subclassResponsibility
]
