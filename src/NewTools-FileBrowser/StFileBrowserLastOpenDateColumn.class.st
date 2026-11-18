"
I am the column showing the date a file was last opened (its access time). `StFileBrowserAbstractColumn` describes how columns are created and used, and `StFileBrowserDateColumn` how dates are displayed; here is what is specific to me.

## Responsibility:

- Show the access time of a `FileReference`.

## Collaborators:

- The code opening a dialog adds me with `aDialog columns:`. I am not a default column.

## Public API and Key Messages

Class side: `title` ('Date Last Opened'), `evaluateOn:`, `priority` (70).

## Examples

```smalltalk
StFileBrowserLastOpenDateColumn scriptFilesTable.
StFileBrowserLastOpenDateColumn column.
```

The first one opens the working directory with the icon, name and my columns; the second one answers my Spec table column.
"
Class {
	#name : 'StFileBrowserLastOpenDateColumn',
	#superclass : 'StFileBrowserDateColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'templateMethod' }
StFileBrowserLastOpenDateColumn class >> evaluateOn: aFileReference [

	^ aFileReference accessTime
]

{ #category : 'sorting' }
StFileBrowserLastOpenDateColumn class >> priority [
	^ 70
]

{ #category : 'templateMethod' }
StFileBrowserLastOpenDateColumn class >> title [
	^ 'Date Last Opened'
]
