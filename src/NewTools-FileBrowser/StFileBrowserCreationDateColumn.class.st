"
I am the column showing the date a file was created. `StFileBrowserAbstractColumn` describes how columns are created and used, and `StFileBrowserDateColumn` how dates are displayed; here is what is specific to me.

## Responsibility:

- Show the creation time of a `FileReference`.

## Collaborators:

- The code opening a dialog adds me with `aDialog columns: { StFileBrowserCreationDateColumn }`, as `StOpenFilePresenter class>>#complexExampleTextPreviewer` does. I am not a default column.

## Public API and Key Messages

Class side: `title` ('Date Created'), `evaluateOn:`, `priority` (60).

## Examples

```smalltalk
StFileBrowserCreationDateColumn scriptFilesTable.
StFileBrowserCreationDateColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserCreationDateColumn',
	#superclass : 'StFileBrowserDateColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'templateMethod' }
StFileBrowserCreationDateColumn class >> evaluateOn: aFileReference [

	^ aFileReference creationTime
]

{ #category : 'sorting' }
StFileBrowserCreationDateColumn class >> priority [
	^ 60
]

{ #category : 'templateMethod' }
StFileBrowserCreationDateColumn class >> title [
	^ 'Date Created'
]
