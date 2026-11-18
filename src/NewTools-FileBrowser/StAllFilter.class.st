"
I am the filter that keeps every entry: the ""no filter"" choice of the file dialogs, shown as 'All'. `StFileBrowserAbstractFilter` describes how filters are created and used; here is what is specific to me.

## Responsibility:

- Keep every `FileReference` (`predicate:` is always true).
- Be the filter used when the code opening a dialog chose none.

## Collaborators:

- `StFileDialogPresenter>>filter` and `StFileNavigationSystemPresenter>>initialize`: create me as their default filter.
- `StFileNavigationSystemPresenter>>filtersCustomization:`: always adds me to the drop list. My priority (150) puts me first.

## Public API and Key Messages

- `predicate:`, `name`: see `StFileBrowserAbstractFilter`.

## Examples

```smalltalk
StAllFilter exampleAllEntries.
```
"
Class {
	#name : 'StAllFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StAllFilter class >> exampleAllEntries [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StAllFilter class >> priority [
	^ 150
]

{ #category : 'accessing' }
StAllFilter >> name [
	^ 'All'
]

{ #category : 'accessing' }
StAllFilter >> predicate: aFileReference [
	^ true
]
