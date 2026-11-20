"
I am the filter that keeps only files, shown as 'Files'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used.

## Responsibility:

- Keep a `FileReference` only when it is a file.
- Offer helpers to filter a collection of entries by extension, by name pattern, or to drop hidden entries.

## Collaborators:

- `StFileNavigationSystemPresenter`: lists and applies me.
- `StFileFilterTest`: the only user of my helpers; the dialogs do not use them.

## Public API and Key Messages

- `predicate: aFileReference`: answers `aFileReference isFile`.
- `files: aCollection withExtensions: extensions`: keeps the directories and the files with one of the extensions.
- `files: aCollection matching: patterns`: keeps the directories and the files whose basename matches one of the patterns (e.g. `'*.st'`).
- `noHiddenFiles: aCollection`: removes the entries whose name starts with a dot, except `..`.
- `directoriesOnly: aCollection`: keeps only the directories.

## Examples

```smalltalk
StFileFilter exampleFilesOnly.
```

`StFileFilterTest` shows the helpers at work.
"
Class {
	#name : 'StFileFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StFileFilter class >> exampleFilesOnly [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StFileFilter class >> priority [
	^ 130
]

{ #category : 'filters' }
StFileFilter >> directoriesOnly: aCollection [
	^ aCollection select: #isDirectory
]

{ #category : 'filtering' }
StFileFilter >> files: aCollection matching: patterns [
	^ aCollection select: [ :each | each isDirectory or: [ patterns anySatisfy: [ :pat | pat match: each basename ] ] ]
]

{ #category : 'filters' }
StFileFilter >> files: aCollection withExtensions: extensions [
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]
]

{ #category : 'accessing' }
StFileFilter >> name [
	^ 'Files'
]

{ #category : 'filters' }
StFileFilter >> noHiddenFiles: aCollection [
	^ aCollection reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ]
]

{ #category : 'accessing' }
StFileFilter >> predicate: aFileReference [
	^ aFileReference isFile
	
]
