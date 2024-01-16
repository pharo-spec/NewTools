"
Implements a basic Spec presenter to display a directory tree.
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
			(CmCommandGroup named: 'StFBDirectoryContextualMenu') asSpecGroup
				register: StFileBrowserNewDirectoryCommand forSpec;			
				register: StFileBrowserRenameCommand forSpec;
				register: StFileBrowserRemoveCommand forSpec;				
				yourself)
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
StDirectoryTreePresenter >> expandPath: aFileLocator [ 
	"Expand the receiver's tree to aFileLocator reference"
	
	| path aPathForSpec currentNode |
	
	path := aFileLocator asPath segments asOrderedCollection.
	aPathForSpec := OrderedCollection new.
	aPathForSpec add: 1.
	
	currentNode := directoryTreePresenter roots anyOne.
	
	path do: [ :aPart | | found |
		found := currentNode directories detect: [ :e | e basename = aPart ] ifNone: [ ^self ].
		aPathForSpec add: (currentNode directories indexOf: found).
		currentNode := found ].

	directoryTreePresenter 
		selectPath: aPathForSpec scrollToSelection: false
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
		contextMenu: [ (self rootCommandsGroup / 'StFBDirectoryContextualMenu') beRoot asMenuPresenter ].
]

{ #category : 'utilities' }
StDirectoryTreePresenter >> openFolder: aFileReference [ 

	model openFolder: aFileReference.
	self owner updateWidgetWithFileReference: aFileReference.
	self expandPath: aFileReference.
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

{ #category : 'utilities' }
StDirectoryTreePresenter >> updateFileSystemContents [

	super updateFileSystemContents.
	directoryTreePresenter roots: StFileSystemItemWrapper roots.
	self expandPath: self currentDirectory.
]
