"
I am the filter that keeps only directories, shown as 'Folders'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used.

## Responsibility:

- Keep a `FileReference` only when it is a directory.

## Collaborators:

- `StFileNavigationSystemPresenter`: lists and applies me. Folder dialogs do not use me: their `StDirectoryNavigationSystemPresenter` lists only directories by itself.

## Public API and Key Messages

- `predicate: aFileReference`: answers `aFileReference isDirectory`.

## Examples

```smalltalk
StDirectoryFilter exampleFoldersOnly.
```
"
Class {
	#name : 'StDirectoryFilter',
	#superclass : 'StFileBrowserAbstractFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StDirectoryFilter class >> exampleFoldersOnly [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StDirectoryFilter class >> priority [
	^ 130
]

{ #category : 'accessing' }
StDirectoryFilter >> name [
	^ 'Folders'
]

{ #category : 'accessing' }
StDirectoryFilter >> predicate: aFileReference [

	^ aFileReference isDirectory
]
