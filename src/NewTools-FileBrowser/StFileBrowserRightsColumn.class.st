"
I am the column showing the access rights of an entry. `StFileBrowserAbstractColumn` describes how columns are created and used; here is what is specific to me.

## Responsibility:

- Show the permissions of a `FileReference`, or 'N/A' when they cannot be read.
- Make the column 110 pixels wide.

## Collaborators:

- `StFileBrowserAbstractPresenter>>defaultColumns`: I am one of the default columns of the file dialogs.

## Public API and Key Messages

Class side: `title` ('Rights'), `evaluateOn:`, `priority` (100).

## Examples

```smalltalk
StFileBrowserRightsColumn scriptFilesTable.
StFileBrowserRightsColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserRightsColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserRightsColumn class >> addConstraintTo: aTableColumn [
	aTableColumn width: 110
]

{ #category : 'templateMethod' }
StFileBrowserRightsColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ [ aFileReference permissions ]
		  on: Error
		  do: [ 'N/A' ]
]

{ #category : 'sorting' }
StFileBrowserRightsColumn class >> priority [
	^ 100
]

{ #category : 'templateMethod' }
StFileBrowserRightsColumn class >> title [
	^ 'Rights'
]
