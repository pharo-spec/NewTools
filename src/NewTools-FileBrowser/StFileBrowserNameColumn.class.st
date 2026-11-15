"
I am the column showing the name of an entry: its basename, e.g. 'something.exe' for 'my/path/something.exe'. `StFileBrowserAbstractColumn` describes how columns are created and used; here is what is specific to me.

## Responsibility:

- Show the basename of a `FileReference`.
- Make the column sortable.

## Collaborators:

- `StFileNavigationSystemPresenter>>columns:`: always adds me, right after the icon column.

## Public API and Key Messages

Class side: `title` ('Name'), `evaluateOn:`, `priority` (1).

## Examples

```smalltalk
StFileBrowserNameColumn scriptFilesTable.
StFileBrowserNameColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserNameColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserNameColumn class >> addConstraintTo: aTableColumn [

	aTableColumn beSortable
]

{ #category : 'templateMethod' }
StFileBrowserNameColumn class >> evaluateOn: aFileReference [

	"I'm provide action for fileReference"

	^ aFileReference basename
]

{ #category : 'sorting' }
StFileBrowserNameColumn class >> priority [
	^ 1
]

{ #category : 'templateMethod' }
StFileBrowserNameColumn class >> title [
	^ 'Name'
]
