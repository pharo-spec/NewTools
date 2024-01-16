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
	#name : 'StFileBrowserAbstractColumn',
	#superclass : 'Object',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserAbstractColumn class >> addContraintTo: aTableColumn [
	"I'm use to add option to column like width ... 
	look at class 
		SpTableColumn"
	self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractColumn class >> column [
	"I'm returning a SpTreeTableColumn"

	| column |
	column := self tableColumnClass title: self title evaluated: self contentValuable.
	self addContraintTo: column.
	^ column
]

{ #category : 'accessing' }
StFileBrowserAbstractColumn class >> columns [
	^ ((self allSubclasses reject: #isAbstract) sort: #priority ascending) collect: #column
]

{ #category : 'templateMethod' }
StFileBrowserAbstractColumn class >> contentValuable [
	^ [ :selectedFileReference | self evaluateOn: selectedFileReference ]
]

{ #category : 'templateMethod' }
StFileBrowserAbstractColumn class >> evaluateOn: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : 'testing' }
StFileBrowserAbstractColumn class >> isAbstract [ 
	^ self = StFileBrowserAbstractColumn
]

{ #category : 'sorting' }
StFileBrowserAbstractColumn class >> priority [
	^ self subclassResponsibility
]

{ #category : 'class' }
StFileBrowserAbstractColumn class >> tableColumnClass [
	^ SpStringTableColumn
]

{ #category : 'templateMethod' }
StFileBrowserAbstractColumn class >> title [
	"I'm returning a String"
	^ self subclassResponsibility
]
