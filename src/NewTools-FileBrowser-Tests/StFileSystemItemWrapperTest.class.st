"
I test the wrappers of the directory tree of the file dialogs (`StFileSystemItemWrapper` and its subclasses).

## Responsibility:

- Check the roots of the tree and the subdirectories of a node.
- Check the label, the kind and the equality of the wrappers.

## Collaborators:

- `StFileSystemItemWrapper` and its subclasses: the classes under test, on a memory file system.
"
Class {
	#name : 'StFileSystemItemWrapperTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FileBrowser-Tests-Wrappers',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Wrappers'
}

{ #category : 'helpers' }
StFileSystemItemWrapperTest >> memoryDirectoryWithChildren [
	"Answer a memory directory holding the folders 'beta' and 'Alpha' and the file 'notes.txt'."

	| directory |
	directory := (FileSystem memory / 'work') ensureCreateDirectory.
	(directory / 'beta') ensureCreateDirectory.
	(directory / 'Alpha') ensureCreateDirectory.
	directory / 'notes.txt' writeStreamDo: [ :stream | stream nextPutAll: 'hello' ].
	^ directory
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testFilesAreFileWrappers [

	| files |
	files := (StDirectoryWrapper on: self memoryDirectoryWithChildren) files.
	self assert: (files collect: [ :each | each label ] as: Array) equals: #( 'notes.txt' ).
	self assert: files first isFile
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testKindsOfWrappers [

	self assert: StDirectoryWrapper exampleWorkingDirectory isDirectory.
	self deny: StDirectoryWrapper exampleWorkingDirectory isRoot.
	self assert: StRootDirectoryWrapper exampleRoot isRoot.
	self assert: StFileWrapper exampleChangesFile isFile.
	self deny: StFileWrapper exampleChangesFile isDirectory.
	self assert: StRootDriveWrapper exampleDriveC isRoot
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testLabelIsTheBasename [

	self assert: (StDirectoryWrapper on: '/my/path/work' asFileReference) label equals: 'work'
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testRootsOutsideWindows [

	OSPlatform current isWindows ifTrue: [ ^ self skip ].
	self assert: StFileSystemItemWrapper roots equals: { StRootDirectoryWrapper exampleRoot }
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testSubdirectoriesAreSortedDirectoryWrappers [

	| subdirectories |
	subdirectories := (StDirectoryWrapper on: self memoryDirectoryWithChildren) subdirectories.
	self assert: (subdirectories collect: [ :each | each label ] as: Array) equals: #( 'Alpha' 'beta' ).
	self assert: (subdirectories allSatisfy: [ :each | each class == StDirectoryWrapper ])
]

{ #category : 'tests' }
StFileSystemItemWrapperTest >> testWrappersOnTheSameReferenceAreEqual [

	| directory |
	directory := self memoryDirectoryWithChildren.
	self assert: (StDirectoryWrapper on: directory) equals: (StDirectoryWrapper on: directory).
	self deny: (StDirectoryWrapper on: directory) equals: (StFileWrapper on: directory)
]
