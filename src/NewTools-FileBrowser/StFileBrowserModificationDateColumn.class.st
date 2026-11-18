"
I am the column showing the date a file was last modified. `StFileBrowserAbstractColumn` describes how columns are created and used, and `StFileBrowserDateColumn` how dates are displayed; here is what is specific to me.

## Responsibility:

- Show the modification time of a `FileReference`, or nothing ('N/A') when it cannot be read.

## Collaborators:

- `StFileBrowserAbstractPresenter>>defaultColumns`: I am one of the default columns of the file dialogs.

## Public API and Key Messages

Class side: `title` ('Date Modified'), `evaluateOn:`, `priority` (50).

## Examples

```smalltalk
StFileBrowserModificationDateColumn scriptFilesTable.
StFileBrowserModificationDateColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserModificationDateColumn',
	#superclass : 'StFileBrowserDateColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'templateMethod' }
StFileBrowserModificationDateColumn class >> evaluateOn: aFileReference [

	^ [ aFileReference modificationTime ]
		  on: Error
		  do: [ nil ]
]

{ #category : 'sorting' }
StFileBrowserModificationDateColumn class >> priority [
	^ 50
]

{ #category : 'templateMethod' }
StFileBrowserModificationDateColumn class >> title [
	^ 'Date Modified'
]
