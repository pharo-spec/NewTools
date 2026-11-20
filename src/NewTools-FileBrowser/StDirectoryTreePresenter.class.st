"
I am the directory tree in the left part of the file browser and of the dialogs. My roots and nodes are `StFileSystemItemWrapper`s, which describe how the tree is built. `StFileBrowserAbstractPresenter` describes how the presenters of a browser work together.

## Responsibility:

- Show the folders of the file system as a tree and expand it to the current folder (`expandPath:`).
- Tell my owner which folder is selected (my output port), so that it opens it.
- Offer the 'StFileBrowserDirectoryContextualMenu' commands (new folder, rename, remove, terminal).

## Collaborators:

- `StFileSystemPresenter`: creates me and opens the folder I transmit.
- `StFileSystemItemWrapper`: the nodes of my tree.

## Public API and Key Messages

- `expandPath: aFileReference`, `updateFileDirectoryTree`, `selectedEntry`.

## Examples

```smalltalk
StDirectoryTreePresenter example.
```

It opens the tree expanded to the working directory.

## Internal Representation

- `directoryTreePresenter`: the tree table.
"
Class {
	#name : 'StDirectoryTreePresenter',
	#superclass : 'StFileBrowserAbstractPresenter',
	#instVars : [
		'directoryTreePresenter'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commander2' }
StDirectoryTreePresenter class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup
		register: (
			(CmCommandGroup named: 'StFileBrowserDirectoryContextualMenu') asSpecGroup
				register: StFileBrowserNewDirectoryCommand forSpec;			
				register: StFileBrowserRenameCommand forSpec;
				register: StFileBrowserRemoveCommand forSpec;
				register: StFileBrowserOpenTerminalCommand forSpec;
				yourself)
]

{ #category : 'examples' }
StDirectoryTreePresenter class >> example [
	"Opens the directory tree alone, as shown in the left pane of the file browser, expanded to the working directory."

	<example>
	| tree |
	tree := self new.
	tree open title: 'Directory tree'.
	tree expandPath: FileLocator workingDirectory asFileReference.
	^ tree
]

{ #category : 'layout' }
StDirectoryTreePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: directoryTreePresenter; 
		yourself
]

{ #category : 'ports' }
StDirectoryTreePresenter >> defaultOutputPort [ 

	^ directoryTreePresenter defaultOutputPort
]

{ #category : 'accessing' }
StDirectoryTreePresenter >> directoryTreePresenter [
	^ directoryTreePresenter
]

{ #category : 'accessing' }
StDirectoryTreePresenter >> expandPath: aFileLocator [
	"Expand the receiver's tree to aFileLocator reference"

	| path aPathForSpec currentNode |
	path := aFileLocator absolutePath segments asOrderedCollection.
	aPathForSpec := OrderedCollection with: 1.

	currentNode := directoryTreePresenter roots anyOne.
	OSPlatform current isWindows ifTrue: [
			currentNode := currentNode asFileReference parent.
			aPathForSpec := OrderedCollection new ]. "This code is (a certainly wrong) way to ensure the treeNavigationPresenter widget points to the right fileSystem (that could be a MemoryStore) as it search for roots of the disk and doesn't allow to check in a MemoryStore " "(currentNode fileReference fileSystem = aFileLocator fileSystem)
        ifFalse: [ directoryTreePresenter roots: { StRootDirectoryWrapper on: aFileLocator fileSystem root }.
                    currentNode fileReference: aFileLocator ]."

	path do: [ :aPart |
			| subdirs |
			subdirs := currentNode directories sorted: [ :a :b | a basename caseInsensitiveLessOrEqual: b basename ].
			currentNode := nil.
			subdirs doWithIndex: [ :subdir :index |
					(currentNode isNil and: [ subdir basename = aPart ]) ifTrue: [
							currentNode := subdir.
							aPathForSpec add: index ] ].
			currentNode ifNil: [ ^ self ] ].

	directoryTreePresenter selectPath: aPathForSpec scrollToSelection: true. "The Morphic `configureScrolling` is executed **AFTER** the desired scroll was configured from the `StDirectoryTreePresenter`. Furthermore, the `configureScrolling` uses the `desiredVisibleRow` which is always set to 1. This statement updates the desired visible row to the last visible index of whatever the selection is pointing to."

	directoryTreePresenter verticalAlignment lastVisibleRowIndex ifNotNil: [ :index |
		directoryTreePresenter verticalAlignment desiredVisibleRow: index ]
]

{ #category : 'initialization' }
StDirectoryTreePresenter >> initializePresenters [

	directoryTreePresenter := self newTreeTable.
	directoryTreePresenter
		addColumn:
			(SpCompositeTableColumn new
				title: 'Directories';
				addColumn:
					(SpImageTableColumn new
						width: 20;
						evaluated: #icon;
						yourself);
				addColumn:
					(SpStringTableColumn new
						evaluated: #label;
						yourself);
				yourself);
		roots: StFileSystemItemWrapper roots;
		children: [ :aClass | aClass subdirectories ];
		beResizable;
		actions: self rootCommandsGroup / 'StFileBrowserDirectoryContextualMenu'
]

{ #category : 'utilities' }
StDirectoryTreePresenter >> openFolder: aFolder [
	"Open aFolder in my owner, which records it in the history. StFileBrowserRemoveCommand sends it to move to the parent of a folder removed from my context menu."

	self owner openFolder: aFolder
]

{ #category : 'accessing' }
StDirectoryTreePresenter >> selectedEntry [
	"Answer a <FileReference> representing the currently selected directory item" 

	^ directoryTreePresenter selectedItem fileReference
]

{ #category : 'asserting' }
StDirectoryTreePresenter >> shouldReparent [
	"A removal was requested from the directory tree, which has the item to be removed as current selection, so we should move to the parent"
	
	^ true
]

{ #category : 'accessing - history' }
StDirectoryTreePresenter >> showFolder: aFolder [
	"Expand the tree to aFolder and select it."

	self expandPath: aFolder
]

{ #category : 'utilities' }
StDirectoryTreePresenter >> updateFileDirectoryTree [

	directoryTreePresenter roots: StFileSystemItemWrapper roots.
	self expandPath: self currentDirectory.
]
