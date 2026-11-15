"
I wrap a file. `StFileSystemItemWrapper` describes how wrappers are created and used; the directory tree itself only shows directories.

## Responsibility:

- Tell that I am a file (`isFile`).
- Give the size of the file as a string, 0 when it does not exist any more.

## Collaborators:

- `StFileSystemItemWrapper>>files` and `allElements`: create me.

## Public API and Key Messages

- `isFile`, `size`.

## Examples

```smalltalk
StFileWrapper exampleChangesFile.
```
"
Class {
	#name : 'StFileWrapper',
	#superclass : 'StFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'examples' }
StFileWrapper class >> exampleChangesFile [

	<sampleInstance>
	^ self on: FileLocator changes asFileReference
]

{ #category : 'testing' }
StFileWrapper >> isFile [

	^ true
]

{ #category : 'private - accessing' }
StFileWrapper >> size [
	
	^ [ fileReference size asString ] on: FileDoesNotExistException do: [ 0 ]
]
