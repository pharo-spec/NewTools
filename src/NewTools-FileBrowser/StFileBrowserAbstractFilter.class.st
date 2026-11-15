"
I am the root of the filters of the file dialogs (`StOpenFilePresenter`, `StSaveFilePresenter`). A filter decides which entries of the current directory the dialog lists, for example only the folders, or only the files with some extensions. The user switches filters with the drop list under the file table.

## Life cycle: who creates filters and who uses them

1. **The code opening a dialog chooses the filter.** It gives the dialog a filter, `aDialog filter: StPNGFilter new`, or extensions that the dialog turns into a `StCustomExtensionsFilter`, `aDialog extensions: #( 'md' ) named: 'Microdown files'`. When nothing is given, the dialog uses a `StAllFilter`. The older entry points do the same: `SpMorphicBackend>>newFileDialogFor:` and the `UITheme` file services (`chooseFileIn:title:extensions:path:preview:`, …) build a `StCustomExtensionsFilter` from their extensions.
2. **The dialog hands it to its navigation presenter.** `StFileDialogPresenter>>filter:` keeps the filter and forwards it to its `StFileNavigationSystemPresenter` (`filter:`).
3. **The navigation presenter fills the drop list.** It calls `StFileBrowserAbstractFilter defaultFiltersWith: theFilter`, which creates one new instance of each default filter class, adds the given filter first when it is not already one of them, and selects it.
4. **The selected filter filters the listing.** Each time the directory or the drop list selection changes, the navigation presenter sends `applyOn:` with the children of the current directory and shows the result (hidden entries are then removed unless `StFileBrowserSettings showHiddenFiles`).
5. **The save dialog completes the typed name.** `StSaveFilePresenter>>selectedEntry` asks the dialog filter whether the name is accepted (`predicate:`) and, if not, to add its extension (`addExtensionTo:`).

Folder dialogs (`StOpenDirectoryPresenter`) do not use filters: their `StDirectoryNavigationSystemPresenter` lists only directories.

## Responsibility:

- Decide, with `predicate:`, whether a `FileReference` is listed.
- Give the name displayed in the drop list.
- Order the filters by priority and create the default filters of the drop list (`defaultFilters`, `defaultFiltersWith:`).

## Collaborators:

- `StFileDialogPresenter`: keeps the filter chosen by its client and forwards it to its navigation presenter; creates `StAllFilter` and `StCustomExtensionsFilter` instances.
- `StFileNavigationSystemPresenter`: creates the default filters through me, shows them in its drop list and applies the selected one.
- `StSaveFilePresenter`: uses the dialog filter to complete the typed file name.
- `FileReference`: the entries I accept or reject.

## Public API and Key Messages

- `predicate: aFileReference`: answers whether the entry is kept. Subclasses define it.
- `name`: the label displayed in the drop list. Subclasses define it.
- `applyOn: aCollection`: answers the entries of the collection that I keep.
- `addExtensionTo: aFileReference`: answers the reference unchanged; extension filters add their extension.
- `StFileBrowserAbstractFilter defaultFilters`: one new instance of each concrete subclass that `canBeDefault`, highest priority first.
- `StFileBrowserAbstractFilter defaultFiltersWith: aFilter`: the default filters, with `aFilter` first when it is not already among them.

## Examples

```smalltalk
StFileBrowserAbstractFilter scriptDefaultFilters.
StFileBrowserAbstractFilter scriptDropListWithCustomFilter.
```

`scriptDefaultFilters` shows how many entries of the working directory each default filter keeps; `scriptDropListWithCustomFilter` shows the drop list of a dialog opened on Microdown files: the custom filter first, then the default filters.

## Internal Representation

I have no state. I use `TComparable`: `<` compares the class-side `priority`, and `=` is a double dispatch (`equalsToNonExtensionFilter:` / `equalsToExtensionFilter:`) so that extension filters compare their extensions. This is how `defaultFiltersWith:` avoids listing the given filter twice.

### Implementation Points

- A subclass is a default filter when `canBeDefault` answers true, which by default means it is not abstract. `StCustomExtensionsFilter` answers false since it needs extensions.
- Higher priority filters come first in the drop list: `StAllFilter` (150), `StDirectoryFilter` and `StFileFilter` (130), extension filters (50), custom extension filters (20).
"
Class {
	#name : 'StFileBrowserAbstractFilter',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StFileBrowserAbstractFilter class >> canBeDefault [
	^ self isAbstract not
]

{ #category : 'actions' }
StFileBrowserAbstractFilter class >> defaultFilters [

	^ ((self allSubclasses select: #canBeDefault) sorted:
		   #priority descending) collect: #new
]

{ #category : 'actions' }
StFileBrowserAbstractFilter class >> defaultFiltersWith: aFilter [

	| defaultFilters |
	defaultFilters := self defaultFilters.
	(defaultFilters includes: aFilter) ifTrue: [ ^ defaultFilters ].
	^ { aFilter } , self defaultFilters
]

{ #category : 'testing' }
StFileBrowserAbstractFilter class >> isAbstract [
	^ self = StFileBrowserAbstractFilter
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter class >> priority [
	^ 1
]

{ #category : 'script' }
StFileBrowserAbstractFilter class >> scriptDefaultFilters [
	"Applies each default filter of the file dialogs to the entries of the working directory and inspects how many entries each one keeps."

	<example>
	| entries |
	entries := FileSystem workingDirectory children.
	(self defaultFilters collect: [ :filter | filter name -> (filter applyOn: entries) size ]) inspect
]

{ #category : 'script' }
StFileBrowserAbstractFilter class >> scriptDropListWithCustomFilter [
	"Inspects the names of the filters a file dialog lists in its drop list when it is opened with a custom filter on Microdown files: the custom filter comes first, followed by the default filters."

	<example>
	((self defaultFiltersWith: (StCustomExtensionsFilter extensions: #( 'md' ) basename: 'Microdown files')) collect: [ :filter |
		 filter name ]) inspect
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> < aComparable [

	"Answer whether the receiver is less than the argument."

	^ self class priority < aComparable class priority
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> = aComparable [

	"Double dispatch"

	^ aComparable equalsToNonExtensionFilter: self
]

{ #category : 'adding' }
StFileBrowserAbstractFilter >> addExtensionTo: aFileReference [

	^ aFileReference
]

{ #category : 'applying' }
StFileBrowserAbstractFilter >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference select: [ :eachFileReference | self predicate: eachFileReference ]
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> equalsToExtensionFilter: aExtensionFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self class = aExtensionFilter class
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> equalsToNonExtensionFilter: aFilter [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self class = aFilter class
]

{ #category : 'comparing' }
StFileBrowserAbstractFilter >> hash [

	"Hash must be redefined whenever = is redefined."

	^ self class priority
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter >> name [
	"Name of the filter to display in the UI."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractFilter >> predicate: aFileReference [
	"I should answer true if the filter should display the file reference as parameter and false if it should filter it."

	^ self subclassResponsibility
]
