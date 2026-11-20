"
I am the root of the wrappers of the directory tree of the file dialogs. A wrapper puts a `FileReference` in the tree: it gives its icon, its label and its subdirectories, themselves wrapped.

## Life cycle: who creates the wrappers and who uses them

1. **The roots are created from the platform.** `StFileSystemItemWrapper roots` answers one `StRootDirectoryWrapper` on `FileSystem root` on macOS and Linux, and one `StRootDriveWrapper` per readable drive on Windows.
2. **The directory tree shows them.** `StDirectoryTreePresenter>>initializePresenters` (and `updateFileDirectoryTree`) uses the roots, asks each node for its `icon` and `label`, and for its `subdirectories` as children: a `StDirectoryWrapper` on each subdirectory, sorted by name ignoring case. `StDirectoryTreePresenter>>expandPath:` walks them to select the current directory.
3. **The bookmarks reuse the roots.** `StFileBrowserBookmark class>>createDriveBookmarks` makes a bookmark of each root, with its label and icon.

## Responsibility:

- Know the wrapped `FileReference` and tell what it is (`isDirectory`, `isFile`, `isRoot`).
- Give its `icon` and `label` for the tree.
- Answer its subdirectories and files, wrapped, or nothing when they cannot be read.

## Collaborators:

- `StDirectoryTreePresenter`: shows the wrappers in its tree.
- `StFileBrowserBookmark`: makes the drive bookmarks from the roots.
- `StFileBrowserIconCache`: gives the icons.

## Public API and Key Messages

- `StFileSystemItemWrapper on: aFileReference`: a new wrapper.
- `StFileSystemItemWrapper roots`: the roots of the tree.
- `subdirectories`, `files`, `allElements`: the wrapped children.
- `icon`, `label`, `asFileReference`.
- `pathString`: the path, with `\` separators on Windows.
- `browseFolder`: opens the folder in the file browser of the operating system.

Two wrappers are equal when they have the same class and the same reference.

## Examples

```smalltalk
StFileSystemItemWrapper scriptDirectoryTree.
```

It opens a tree of wrappers starting at the working directory, rather than at the roots of the file system as the dialogs do. `StFileSystemItemWrapperTest` checks the children and labels.

## Internal Representation

- `fileReference`: the wrapped `FileReference`.
"
Class {
	#name : 'StFileSystemItemWrapper',
	#superclass : 'Object',
	#instVars : [
		'fileReference'
	],
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'accessing' }
StFileSystemItemWrapper class >> icon [ 
	^self iconProvider folderIcon 
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> iconProvider [ 

	^ StFileBrowserIconCache 
]

{ #category : 'testing' }
StFileSystemItemWrapper class >> isAbstract [ 

	^self name = #HRBFileSystemItemWrapper
]

{ #category : 'instance creation' }
StFileSystemItemWrapper class >> on: aFileReference [

	^(self new)
		fileReference: aFileReference;
		yourself
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> roots [

	^ OSPlatform current isWindows
		  ifTrue: [
				  FileSystem root directories
					  select: [ :each | each exists and: [ each isReadable ] ]
					  thenCollect: [ :each | StRootDriveWrapper on: each ] ]
		  ifFalse: [ Array with: (StRootDirectoryWrapper on: FileSystem root) ]
]

{ #category : 'script' }
StFileSystemItemWrapper class >> scriptDirectoryTree [
	"Opens a directory tree made of wrappers, as the file dialogs show it, but starting at the working directory instead of the roots of the file system: each node is a StDirectoryWrapper whose children are its wrapped subdirectories, with their icon and label."

	<example>
	| tree |
	tree := SpEasyTreeListViewPresenter new
		        roots: { (StDirectoryWrapper on: FileLocator workingDirectory asFileReference) };
		        children: [ :wrapper | wrapper subdirectories ];
		        displayIcon: [ :wrapper | wrapper icon ];
		        display: [ :wrapper | wrapper label ];
		        expandRoots;
		        yourself.
	^ tree open
		  title: 'Directory tree of the working directory';
		  yourself
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> systemIcon [

	^self isAbstract ifTrue: [ super systemIcon ] ifFalse: [ self icon ]
]

{ #category : 'comparing' }
StFileSystemItemWrapper >> = aStFBFileSystemItemWrapper [

	self == aStFBFileSystemItemWrapper
		ifTrue: [ ^ true ].
	^ self class = aStFBFileSystemItemWrapper class and: [
			fileReference = aStFBFileSystemItemWrapper fileReference ]
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> allElements [  
	
	^(OrderedCollection withAll: self subdirectories) 
		addAll: self files; 
		yourself
]

{ #category : 'converting' }
StFileSystemItemWrapper >> asFileReference [ 

	^self fileReference
]

{ #category : 'actions' }
StFileSystemItemWrapper >> browseFolder [
	fileReference openInOSFileBrowser 
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> directories [ 

	^ [ self fileReference directories sorted: [ :a :b | a basename caseInsensitiveLessOrEqual: b basename ] ]
		on: Exception do: [ #() ]
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> fileReference [
	^ fileReference
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> files [ 
	
	^ [ fileReference files
			collect: [:each | StFileWrapper on: each ] ]
		on: FileException 
		do: [ #() ]
]

{ #category : 'comparing' }
StFileSystemItemWrapper >> hash [

	^ fileReference hash
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> icon [

	^ self class icon
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isDirectory [

	^ false
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isFile [

	^false
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isRoot [ 
	^false
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> label [

	^ self fileReference basename
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> pathString [
 
	| path |
	path := self fileReference fullPath pathString.
	^ OSPlatform current isWindows 
		ifTrue: [ path allButFirst copyReplaceAll: '/' with: '\' ]
		ifFalse: [ path ]
]

{ #category : 'printing' }
StFileSystemItemWrapper >> printOn: aStream [
	
	super printOn: aStream.
	aStream << ' ['.
	fileReference printOn: aStream.
	aStream << ']'.

]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> size [ 
	^''
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> subdirectories [ 
	
	^ self directories collect: [:each | StDirectoryWrapper on: each ] 
]
