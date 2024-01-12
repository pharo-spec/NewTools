"
Implements a basic Spec presenter to display a directory tree.
"
Class {
	#name : 'StFBDirectoryTreePresenter',
	#superclass : 'StPresenter',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'directoryTreePresenter'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildBrowsingOperationsGroupWith: presenterInstance [

]

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup
		register: (self buildStFBDirectoryContextualGroupWith: presenterInstance)
]

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildListingOperationsGroupWith: presenterInstance [


]

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildSelectionOperationsGroupWith: presenterInstance [

]

{ #category : 'commander2' }
StFBDirectoryTreePresenter class >> buildStFBDirectoryContextualGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'StFBDirectoryContextualMenu') asSpecGroup
		register: (self buildBrowsingOperationsGroupWith: presenterInstance);
		register: (self buildListingOperationsGroupWith: presenterInstance);
		register: (self buildSelectionOperationsGroupWith: presenterInstance);
		yourself
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
