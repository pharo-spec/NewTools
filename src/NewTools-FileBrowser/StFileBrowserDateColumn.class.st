"
I am the abstract root of the date columns: modification, creation and last opened dates. `StFileBrowserAbstractColumn` describes how columns are created and used; I add what the date columns share.

## Responsibility:

- Display a date as day, abbreviated month, year and time, e.g. '5 Nov 2026 09:07', or 'N/A' when there is no date.
- Make the date columns 150 pixels wide and sortable.

## Collaborators:

- `StFileBrowserModificationDateColumn`, `StFileBrowserCreationDateColumn`, `StFileBrowserLastOpenDateColumn`: my subclasses give the title, the date and the priority.

## Public API and Key Messages

- `formatOn: aDateAndTime`: the displayed date.
- `addConstraintTo: aTableColumn`: width, formatting and sorting.

## Examples

```smalltalk
StFileBrowserDateColumn scriptFilesTable.
```

It opens the working directory with the three date columns. The date format is checked by `StFileBrowserColumnTest`.
"
Class {
	#name : 'StFileBrowserDateColumn',
	#superclass : 'StFileBrowserAbstractColumn',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserDateColumn class >> addConstraintTo: aTableColumn [

	aTableColumn
		width: 150;
		formatted: [ :v | self formatOn: v ];
		beSortable
]

{ #category : 'templateMethod' }
StFileBrowserDateColumn class >> formatOn: aValue [

	aValue ifNil: [ ^ 'N/A' ].
	^ '{1} {2} {3} {4}' format: {
			  aValue dayOfMonth asString.
			  aValue monthAbbreviation.
			  aValue year asString.
			  (aValue asTime print24 first: 5) }
]

{ #category : 'testing' }
StFileBrowserDateColumn class >> isAbstract [

	^ self == StFileBrowserDateColumn
]
