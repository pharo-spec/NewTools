"
I wrap `FileSystem root`, the only root of the directory tree on macOS and Linux. `StFileSystemItemWrapper` describes how wrappers are created and used.

## Responsibility:

- Tell that I am a root (`isRoot`).

## Collaborators:

- `StFileSystemItemWrapper class>>roots`: creates me outside Windows.

## Public API and Key Messages

- `isRoot`: true; the rest is inherited.

## Examples

```smalltalk
StRootDirectoryWrapper exampleRoot.
```
"
Class {
	#name : 'StRootDirectoryWrapper',
	#superclass : 'StDirectoryWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'examples' }
StRootDirectoryWrapper class >> exampleRoot [

	<sampleInstance>
	^ self on: FileSystem root
]

{ #category : 'testing' }
StRootDirectoryWrapper >> isRoot [

	^ true
]
