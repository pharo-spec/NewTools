"
Implements a basic Spec presenter to display a directory tree.
"
Class {
	#name : 'StFBDirectoryTreePresenter',
	#superclass : 'StFBAbstractPresenter',
	#instVars : [
		'directoryTreePresenter'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup
		register: (
			(CmCommandGroup named: 'StFBDirectoryContextualMenu') asSpecGroup
				register: StFBNewFolderCommand forSpec;			
				register: StFBRenameCommand forSpec;
				register: StFBRemoveCommand forSpec;				
				yourself)
]

{ #category : 'layout' }
StFBDirectoryTreePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: directoryTreePresenter; 
		yourself
]

{ #category : 'ports' }
StFBDirectoryTreePresenter >> defaultOutputPort [ 

	^ directoryTreePresenter defaultOutputPort
]

{ #category : 'accessing' }
StFBDirectoryTreePresenter >> expandPath: aFileLocator [ 
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
StFBDirectoryTreePresenter >> initializePresenters [

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
		roots: StFBFileSystemItemWrapper roots;
		children: [ :aClass | aClass subdirectories ];
		beResizable;
		contextMenu: [ (self rootCommandsGroup / 'StFBDirectoryContextualMenu') beRoot asMenuPresenter ].
]

{ #category : 'utilities' }
StFBDirectoryTreePresenter >> openFolder: aFileReference [ 

	model openFolder: aFileReference.
	self owner updateWidgetWithFileReference: aFileReference.
	self expandPath: aFileReference.
]

{ #category : 'accessing' }
StFBDirectoryTreePresenter >> selectedEntry [
	"Answer a <FileReference> representing the currently selected directory item" 

	^ directoryTreePresenter selectedItem fileReference
]

{ #category : 'asserting' }
StFBDirectoryTreePresenter >> shouldReparent [
	"A removal was requested from the directory tree, which has the item to be removed as current selection, so we should move to the parent"
	
	^ true
]

{ #category : 'utilities' }
StFBDirectoryTreePresenter >> updateFileSystemContents [

	super updateFileSystemContents.
	directoryTreePresenter roots: StFBFileSystemItemWrapper roots.
	self expandPath: self currentDirectory.
]
