"
I am the file browser: a directory tree and a bookmark tree on the left, and on the right a navigation presenter with the path, the file table, the filters and a preview pane. I replace the old FileList tool. The file dialogs are my subclasses. `StFileBrowserAbstractPresenter` describes how the presenters of a browser are created and work together.

## Responsibility:

- Create and lay out my three parts: the navigation presenter (`navigationSystemClass`), the directory tree and the bookmark tree.
- Keep them in sync: open the folder selected in the tree or in the bookmarks, and refresh them all (`updateFileSystemPresenters`).
- Show the bookmarks and add the ones the user asks for.

## Collaborators:

- `StFileNavigationSystemPresenter`: my right part.
- `StDirectoryTreePresenter`: my directory tree.
- `StFileBrowserAbstractBookMark` and its subclasses: the bookmarks of my bookmark tree, with the 'StFileBrowserBookmarksMenu' commands.
- `StFileBrowserAbstractColumn`: I give the default columns to the navigation presenter.

## Public API and Key Messages

- `StFileSystemPresenter open`: opens the file browser.
- `disablePreview`: hides the preview pane.
- `openFolder: aFileReference`, `expandPath: aFileReference`.
- `title: aString`, `bookmarks: aCollection`.
- `fileNavigationSystem`, `treeNavigationSystem`, `bookmarksTreeTable`: my parts.

## Examples

```smalltalk
StFileSystemPresenter open.
StFileSystemPresenter exampleWithoutPreview.
```
"
Class {
	#name : 'StFileSystemPresenter',
	#superclass : 'StFileBrowserAbstractPresenter',
	#instVars : [
		'treeNavigationSystem',
		'fileNavigationSystem',
		'bookmarksTreeTable',
		'title'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commands' }
StFileSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [

	rootCommandGroup
		register:
			((CmCommandGroup named: 'StFileBrowserBookmarksMenu') asSpecGroup
				register: StFileBrowserRemoveBookmarkCommand forSpec;
				yourself)
]

{ #category : 'accessing' }
StFileSystemPresenter class >> defaultPreferredExtent [

	^ (1100 @ 700)
]

{ #category : 'examples' }
StFileSystemPresenter class >> exampleWithoutPreview [
	"Opens the file browser without its preview pane."

	<example>
	^ self new
		  disablePreview;
		  open;
		  yourself
]

{ #category : 'hooks' }
StFileSystemPresenter class >> navigationSystemClass [

	^ StFileNavigationSystemPresenter
]

{ #category : 'instance creation' }
StFileSystemPresenter class >> open [ 
	<script>

	^ self new open
]

{ #category : 'class initialization' }
StFileSystemPresenter class >> registerToolsOn: aRegistry [

	aRegistry register: self as: #fileList
]

{ #category : 'accessing - bookmarks' }
StFileSystemPresenter >> addBookmark: aFileReference [ 

	self model addBookmark: aFileReference.
	bookmarksTreeTable 
		roots: self bookmarks;
		expandRoots;
		refresh.

]

{ #category : 'accessing - bookmarks' }
StFileSystemPresenter >> bookmarks: aCollectionOfFDGroupBookMark [

	bookmarksTreeTable roots: aCollectionOfFDGroupBookMark 
]

{ #category : 'accessing - bookmarks' }
StFileSystemPresenter >> bookmarksTreeTable [
	"See superimplementor's comment"

	^ bookmarksTreeTable.
]

{ #category : 'initialization' }
StFileSystemPresenter >> connectPresenters [
	"Here we check that the window is displayed. 
	If it's not, that means this is a first opening so it should preserve the path selected by the user (through openOnLastDirectory preference, or defaultRoot: message send) and not to transmit the directory selection.
	A selection of the current directory is not transmitted: it comes from opening that folder, which expands the tree to it, and the folder is already shown.
	Once displayed, the directory tree is expanded to the current directory, so that it shows the same folder as the file table: it cannot be expanded before."

	super connectPresenters.

	treeNavigationSystem transmitDo: [ :selection |
		(self isDisplayed and: [ selection isNotNil and: [ selection fileReference ~= self currentDirectory ] ]) ifTrue: [
			self updateWidgetWithFileReference: selection fileReference ] ].

	bookmarksTreeTable whenSelectionChangedDo: [ :selection |
		selection selectedItem ifNotNil: [ :selectedItem |
			selectedItem isComposite ifFalse: [ self fileNavigationSystem openFolder: selectedItem location ] ] ].

	self whenDisplayDo: [
		self centered.
		self expandPath: self currentDirectory ]
]

{ #category : 'layout' }
StFileSystemPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
			positionOfSlider: 200;
			add: (SpPanedLayout newTopToBottom
				positionOfSlider: 300;
					add: treeNavigationSystem;
					add: bookmarksTreeTable;
					yourself);
			add: fileNavigationSystem;
			yourself
]

{ #category : 'accessing' }
StFileSystemPresenter >> disablePreview [

	self fileNavigationSystem showPreview: false
]

{ #category : 'accessing' }
StFileSystemPresenter >> expandPath: aFileReference [ 
	"Expand the directory's navigation tree to aFileReference"

	treeNavigationSystem expandPath: aFileReference
]

{ #category : 'accessing' }
StFileSystemPresenter >> fileNavigationSystem [

	^ fileNavigationSystem
]

{ #category : 'initialization' }
StFileSystemPresenter >> initializeBookmarksTreeTable [

	bookmarksTreeTable := self newTreeTable.
	bookmarksTreeTable
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn new
				 addColumn:
					 (SpImageTableColumn evaluated: [ :each | each icon ])
						 beNotExpandable;
				 addColumn:
					 (SpStringTableColumn evaluated: [ :groupBookMark | 
							  groupBookMark name ]);
				 yourself);
		roots: self bookmarks;
		children: #children;
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'StFileBrowserBookmarksMenu' ];
		expandRoots
]

{ #category : 'initialization' }
StFileSystemPresenter >> initializePresenters [

	fileNavigationSystem := self instantiate: self navigationSystemClass on: self model.
	fileNavigationSystem columns: self defaultColumns.
	fileNavigationSystem nameText disable.

	treeNavigationSystem := self instantiate: StDirectoryTreePresenter on: self model.

	self initializeBookmarksTreeTable.
]

{ #category : 'utilities' }
StFileSystemPresenter >> openFolder: aFileReference [

	fileNavigationSystem updateWidgetWithFileReference: aFileReference.
	model openFolder: aFileReference.
	self expandPath: aFileReference.

]

{ #category : 'accessing' }
StFileSystemPresenter >> title: aString [

	title := aString
]

{ #category : 'accessing' }
StFileSystemPresenter >> treeNavigationSystem [
	^ treeNavigationSystem
]

{ #category : 'utilities' }
StFileSystemPresenter >> updateFileSystemPresenters [

	fileNavigationSystem updateFileReferenceTable.
	treeNavigationSystem updateFileDirectoryTree.


]

{ #category : 'utilities' }
StFileSystemPresenter >> updateTreeNavigationWithFileReference: aFileReference [ 

	treeNavigationSystem updateWidgetWithFileReference: aFileReference
]

{ #category : 'accessing - history' }
StFileSystemPresenter >> updateWidgetWithFileReference: aFileReference [ 

	fileNavigationSystem updateWidgetWithFileReference: aFileReference
]

{ #category : 'accessing' }
StFileSystemPresenter >> windowIcon [ 

	^ self iconNamed: #open

]

{ #category : 'accessing' }
StFileSystemPresenter >> windowTitle [

	^  title ifNil: [ title := 'File browser' ]
]
