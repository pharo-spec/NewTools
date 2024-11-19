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
			(CmCommandGroup named: 'StFileBrowserDirectoryContextualMenu') asSpecGroup
				register: StFileBrowserNewDirectoryCommand forSpec;			
				register: StFileBrowserRenameCommand forSpec;
				register: StFileBrowserRemoveCommand forSpec;
				register: StFileBrowserOpenTerminalCommand forSpec;
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
	Smalltalk os isWindows ifTrue: [
		currentNode := currentNode asFileReference parent.
		aPathForSpec := OrderedCollection new ].

	path do: [ :aPart |
		| subdirs |
		subdirs := currentNode directories sorted: [ :a :b |
			           a basename caseInsensitiveLessOrEqual: b basename ].
		currentNode := nil.
		subdirs doWithIndex: [ :subdir :index |
			(currentNode isNil and: [ subdir basename = aPart ]) ifTrue: [
				currentNode := subdir.
				aPathForSpec add: index ] ].
		currentNode ifNil: [ ^ self ] ].

	directoryTreePresenter
		selectPath: aPathForSpec
		scrollToSelection: true.

	"The Morphic `configureScrolling` is executed **AFTER** the desired scroll was configured from the `StDirectoryTreePresenter`. Furthermore, the `configureScrolling` uses the `desiredVisibleRow` which is always set to 1. This statement updates the desired visible row to the last visible index of whatever the selection is pointing to."

	directoryTreePresenter verticalAlignment desiredVisibleRow:
		directoryTreePresenter verticalAlignment lastVisibleRowIndex
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
StDirectoryTreePresenter >> openFolder: aFileReference [ 

	self owner updateWidgetWithFileReference: aFileReference.

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
StDirectoryTreePresenter >> updateFileDirectoryTree [

	directoryTreePresenter roots: StFileSystemItemWrapper roots.
	self expandPath: self currentDirectory.
]

{ #category : 'utilities' }
StDirectoryTreePresenter >> updateWidgetWithFileReference: aFileReference [

	self expandPath: aFileReference.
]
