"
General file system presenter, which replaces the older FileList tool.

# Examples

The default File Browser (without specifying any options), will open a presenter with Tree Navigation, Bookmarks, Breadcrumb, Navigation Buttons, File List, Filters and Preview:
```smalltalk
StFileSystemPresenter new open.
```

Open a File Browser without the preview presenter:
```smalltalk
StFileSystemPresenter new
	disablePreview;
	open.
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
	If it's not, that means this is a first opening so it should preserve the path selected by the user (through openOnLastDirectory preference, or defaultRoot: message send) and not to transmit the directory selection"

	super connectPresenters.

	treeNavigationSystem transmitDo: [ :selection |
			(self isDisplayed and: [ selection isNotNil ]) ifTrue: [
				self updateWidgetWithFileReference: selection fileReference ] ].

	bookmarksTreeTable whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ :selectedItem |
					selectedItem isComposite ifFalse: [
						self fileNavigationSystem openFolder: selectedItem location ] ] ].

	self whenDisplayDo: [ self centered ]
]

{ #category : 'layout' }
StFileSystemPresenter >> defaultLayout [

	^ SpScrollableLayout with: (SpPanedLayout newLeftToRight
			   positionOfSlider: 0.2;
			   add: (SpPanedLayout newTopToBottom
					    positionOfSlider: 300;
					    add: treeNavigationSystem;
					    add: bookmarksTreeTable;
					    yourself);
			   add: fileNavigationSystem) yourself
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
