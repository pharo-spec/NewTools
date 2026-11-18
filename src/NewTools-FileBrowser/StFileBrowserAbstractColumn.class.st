"
I am the root of the columns of the file table of the file dialogs: icon, name, dates, size, rights. Each subclass describes one column: its title, what it shows for a `FileReference`, its place among the columns and its options (width, formatting, sorting).

My subclasses are never instantiated: the class is the column description, so all my API is on the class side.

## Life cycle: who creates the columns and who uses them

1. **The file table starts with every column.** `StFileNavigationSystemPresenter>>initializeFilesTable` gives its table `StFileBrowserAbstractColumn columns`: the table column of each concrete subclass, by priority.
2. **File dialogs then choose the default columns.** `StFileSystemPresenter>>initializePresenters`, and so every file dialog, sets the columns of its navigation presenter to `StFileBrowserAbstractPresenter>>defaultColumns`: modification date, size and rights.
3. **The code opening a dialog may choose others.** `aDialog columns: { StFileBrowserCreationDateColumn }` (`StFileDialogPresenter>>columns:`) forwards the column classes to the navigation presenter. `StFileNavigationSystemPresenter>>columns:` always adds the icon and name columns, sorts the classes by `priority`, and asks each one for its `column`.
4. **A column class builds a Spec table column.** `column` creates an instance of `tableColumnClass` (`SpStringTableColumn` by default) with my `title` and a block calling `evaluateOn:`, then `addConstraintTo:` sets its width, its formatting (`formatOn:`) and makes it sortable.
5. **The table shows it.** For each `FileReference` of the current directory, the table evaluates the block, so `evaluateOn:` answers the value of the cell.

## Responsibility:

- Give the title of a column and the value it shows for a `FileReference`.
- Give the place of the column in the table (`priority`) and its options.
- Build the Spec table column (`column`) and the list of all columns (`columns`).

## Collaborators:

- `StFileNavigationSystemPresenter`: shows my table columns in its file table.
- `StFileSystemPresenter` / `StFileBrowserAbstractPresenter`: choose the default columns of the file dialogs.
- `StFileDialogPresenter`: receives the columns chosen by the code opening a dialog.
- `SpStringTableColumn`, `SpImageTableColumn`: the Spec table columns I build.

## Public API and Key Messages

Class side:

- `title`: the column header. Subclasses define it.
- `evaluateOn: aFileReference`: the value of the cell. Subclasses define it.
- `priority`: the place of the column, smaller first. Subclasses define it.
- `addConstraintTo: aTableColumn`: sets the width, formatting and sorting. Subclasses define it.
- `formatOn: aValue`: the string displayed for a value, used by the columns that format their cells.
- `tableColumnClass`: the Spec table column class to use.
- `column`: a new Spec table column for this column.
- `StFileBrowserAbstractColumn columns`: the table columns of all the concrete subclasses, by priority.

## Examples

```smalltalk
StFileBrowserAbstractColumn scriptFilesTable.
```

It opens the working directory in a table with all the columns. Send `scriptFilesTable` to any column class to see that column after the icon and name columns (checked by `StFileBrowserColumnTest`).

### Implementation Points

- Priorities: icon 0, name 1, modification date 50, creation date 60, last opened date 70, size 90, rights 100.
- A column class is abstract when `isAbstract` answers true; `columns` skips it.
"
Class {
	#name : 'StFileBrowserAbstractColumn',
	#superclass : 'Object',
	#category : 'NewTools-FileBrowser-Columns',
	#package : 'NewTools-FileBrowser',
	#tag : 'Columns'
}

{ #category : 'adding' }
StFileBrowserAbstractColumn class >> addConstraintTo: aTableColumn [
	"I'm use to add option to column like width ... 
	look at class <SpTableColumn>"

	self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractColumn class >> column [
	"I'm returning a SpTreeTableColumn"

	| column |
	column := self tableColumnClass title: self title evaluated: self contentValuable.
	self addConstraintTo: column.
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

{ #category : 'templateMethod' }
StFileBrowserAbstractColumn class >> formatOn: aValue [
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

{ #category : 'script' }
StFileBrowserAbstractColumn class >> scriptFilesTable [
	"Opens the entries of the working directory in a table, as a file dialog shows them: the icon and name columns, followed by the receiver column, or by all the concrete columns below the receiver when it is abstract. Send it to any column class, e.g. StFileBrowserSizeColumn scriptFilesTable."

	<example>
	| columnClasses table |
	columnClasses := (self isAbstract
		                  ifTrue: [ self allSubclasses reject: [ :each | each isAbstract ] ]
		                  ifFalse: [ { self } ]) asSet.
	columnClasses addAll: {
			StFileBrowserIconColumn.
			StFileBrowserNameColumn }.
	table := SpEasyColumnViewPresenter new
		         columns:
			         ((columnClasses asOrderedCollection sort: [ :a :b | a priority <= b priority ]) collect: [ :each | each column ]);
		         items: FileSystem workingDirectory children;
		         yourself.
	^ table open
		  title: self name;
		  yourself
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
