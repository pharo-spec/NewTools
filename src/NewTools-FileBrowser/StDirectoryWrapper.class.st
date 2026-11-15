"
I wrap a directory in the directory tree of the file dialogs. `StFileSystemItemWrapper` describes how wrappers are created and used.

## Responsibility:

- Tell that I am a directory (`isDirectory`), so that the tree shows me as a folder.

## Collaborators:

- `StFileSystemItemWrapper>>subdirectories`: creates me for each subdirectory of a node.

## Public API and Key Messages

- `isDirectory`: true; the rest is inherited.

## Examples

```smalltalk
StDirectoryWrapper exampleWorkingDirectory.
```
"
Class {
	#name : 'StDirectoryWrapper',
	#superclass : 'StFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'examples' }
StDirectoryWrapper class >> exampleWorkingDirectory [

	<sampleInstance>
	^ self on: FileLocator workingDirectory asFileReference
]

{ #category : 'testing' }
StDirectoryWrapper >> isDirectory [

	^true
]
