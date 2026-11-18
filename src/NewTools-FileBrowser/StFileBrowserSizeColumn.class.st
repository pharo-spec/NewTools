"
I am the column showing the size of a file in a human readable form, e.g. '1.50 kB'. `StFileBrowserAbstractColumn` describes how columns are created and used; here is what is specific to me.

## Responsibility:

- Show the size of a file, 0 for a directory or when the size cannot be read.
- Display it in SI units, or 'N/A' when there is no size.
- Make the column 70 pixels wide and sortable.

## Collaborators:

- `StFileBrowserAbstractPresenter>>defaultColumns`: I am one of the default columns of the file dialogs.

## Public API and Key Messages

Class side: `title` ('Size'), `evaluateOn:`, `priority` (90), `formatOn:`.

## Examples

```smalltalk
StFileBrowserSizeColumn scriptFilesTable.
StFileBrowserSizeColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserSizeColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserSizeColumn class >> addConstraintTo: aTableColumn [

	aTableColumn
		formatted: [ :e | self formatOn: e ];
		width: 70;
		beSortable
]

{ #category : 'templateMethod' }
StFileBrowserSizeColumn class >> evaluateOn: aFileReference [

	^ aFileReference isDirectory
		  ifTrue: [ 0 ]
		  ifFalse: [
			  [ aFileReference size ]
				  on: Error
				  do: [ 0 ] ]
]

{ #category : 'templateMethod' }
StFileBrowserSizeColumn class >> formatOn: aSize [

	^ aSize ifNil: [ 'N/A' ] ifNotNil: [
		  [ aSize humanReadableSISizeString ]
			  on: Error
			  do: [ 'N/A' ] ]
]

{ #category : 'sorting' }
StFileBrowserSizeColumn class >> priority [
	^ 90
]

{ #category : 'templateMethod' }
StFileBrowserSizeColumn class >> title [
	^ 'Size'
]
