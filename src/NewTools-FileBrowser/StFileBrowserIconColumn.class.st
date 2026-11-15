"
I am the column showing an icon telling whether an entry is a folder or a file. `StFileBrowserAbstractColumn` describes how columns are created and used; here is what is specific to me.

## Responsibility:

- Show the folder icon for a directory and the file icon otherwise.
- Use an image column (`SpImageTableColumn`) 20 pixels wide.

## Collaborators:

- `StFileNavigationSystemPresenter>>columns:`: always adds me, first.
- `StFileBrowserIconCache`: gives me the icons.

## Public API and Key Messages

Class side: `title` (empty), `evaluateOn:`, `priority` (0), `tableColumnClass` (`SpImageTableColumn`).

## Examples

```smalltalk
StFileBrowserIconColumn scriptFilesTable.
StFileBrowserIconColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserIconColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserIconColumn class >> addConstraintTo: aTableColumn [
	aTableColumn width: 20
]

{ #category : 'templateMethod' }
StFileBrowserIconColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ StFileBrowserIconCache iconNamed: (aFileReference isDirectory
			   ifTrue: [ #folderIcon ]
			   ifFalse: [ #fileIcon ])
]

{ #category : 'sorting' }
StFileBrowserIconColumn class >> priority [
	^ 0
]

{ #category : 'class' }
StFileBrowserIconColumn class >> tableColumnClass [
	^ SpImageTableColumn
]

{ #category : 'templateMethod' }
StFileBrowserIconColumn class >> title [
	^ ''
]
