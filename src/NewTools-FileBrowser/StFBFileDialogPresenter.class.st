"
Abstract base class for different styles of opening/saving.
Do not use this class directly, instead check subclasses to see specific uses.

## Author 

- Main Author : peteruhnak
- Migrator Spec 1 to Spec 2 : CafeKrem (github pseudo)
- Authors: Esteban Lorenzano, Hernán Morales Durand.

## Examples

```smalltalk
StFBFileDialogPresenter fullExample
```

```smalltalk
FDOpenFileDialog open
```

## Customization

This class defines methods to customize your File Dialog Presenters

- `whenSelected: aBlock` : Used to define the action of the accept button
- `bookmarks: aCollection Of FDAbstractBookMark` Used to set bookmarks use the class `StFBAbstractBookMark`. You can create group with `StFBGroupBookmark` or use `StFBBookmark` to create bookmark.	  
- `defaultFolder: aPath` Used to open a fileDialog on a aPath, this path must exist and be a directory

```smalltalk
(StFBOpenFileDialog new defaultFolder: '/home/cdutriez/' asFileReference) open 
```

- `filtersCustomization: aCollection` Used to define a set of Filter (choose one or more among `StFBAbstractPredicate` or create a new  predicate)

There is always a default filter (`filterNothing`)

```smalltalk		
(StFBOpenFileDialog new filtersCustomization: { StFBJPGAndPNGPredicate new }) open
```

	
## Icons

If you want to add icons you just have to create a method with pragma <icons> and this method have to return an array of association 

FDFileDialogPresenter textIcons method 

"
Class {
	#name : 'StFBFileDialogPresenter',
	#superclass : 'StFBAbstractPresenter',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'fileNavigationSystem',
		'okAction',
		'title',
		'filter'
	],
	#classVars : [
		'OkAction'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'icons' }
StFBFileDialogPresenter class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: StFBFileDialogPresenter class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : 'commander2' }
StFBFileDialogPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: StFBRemoveBookmarkCommand forSpec;
				yourself)
]

{ #category : 'examples' }
StFBFileDialogPresenter class >> chooseModal [

	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	^ self new openModal
]

{ #category : 'examples' }
StFBFileDialogPresenter class >> chooseModalAndInspect [

	^ self chooseModal inspect
]

{ #category : 'examples' }
StFBFileDialogPresenter class >> chooseModalIfNone: aBlock [

	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	^ self chooseModal ifNil: aBlock
]

{ #category : 'examples' }
StFBFileDialogPresenter class >> chooseThenDo: aBlock [

	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	<example>
	^ (self on: StFBFileSystemModel new)
		  okAction: aBlock;
		  open
]

{ #category : 'examples' }
StFBFileDialogPresenter class >> chooseThenInspect [

	^ self chooseThenDo: [ :file | file inspect ]
]

{ #category : 'specs' }
StFBFileDialogPresenter class >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 200;
		  add: #bookmarksTreeTable;
		  add: #fileNavigationSystem;
		  yourself
]

{ #category : 'defaultClassVariable' }
StFBFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | fileReference ]
]

{ #category : 'accessing - Class' }
StFBFileDialogPresenter class >> extensions: aCollectionOfExtensions [

	^ self new
		  extensions: aCollectionOfExtensions;
		  openDialog;
		  yourself
]

{ #category : 'accessing - Class' }
StFBFileDialogPresenter class >> extensions: aCollectionOfExtensions named: aString [

	^ self new
		  extensions: aCollectionOfExtensions named: aString;
		  openDialog;
		  yourself
]

{ #category : 'class initialization' }
StFBFileDialogPresenter class >> initialize [

	OkAction := self defaultOkActionBlock.

]

{ #category : 'icons' }
StFBFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
	(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : 'hooks' }
StFBFileDialogPresenter >> allowsChooseDirectoryIfNoFilename [

	^ false
]

{ #category : 'accessing - ui' }
StFBFileDialogPresenter >> cancelLabel [

	^ 'Cancel'
]

{ #category : 'testing' }
StFBFileDialogPresenter >> cancelled [

	^ self withWindowDo: [ :w | w cancelled ]
]

{ #category : 'api - customization' }
StFBFileDialogPresenter >> columns: aCollectionOfColumns [
	fileNavigationSystem columns: aCollectionOfColumns 
]

{ #category : 'actions' }
StFBFileDialogPresenter >> confirm [

	self withWindowDo: #triggerOkAction
]

{ #category : 'accessing - ui' }
StFBFileDialogPresenter >> confirmLabel [

	^ 'Accept'
]

{ #category : 'actions' }
StFBFileDialogPresenter >> confirmed [

	okAction cull: self selectedEntry
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> connectPresenters [

	bookmarksTreeTable whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :selectedItem | 
			selectedItem isComposite ifFalse: [ 
				fileNavigationSystem openFolder: selectedItem location ] ] ]
]

{ #category : 'api - customization' }
StFBFileDialogPresenter >> defaultFolder: aPath [
	fileNavigationSystem defaultFolder: aPath
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> extensions: aCollectionOfExtensions [

	self filter:
		(StFBCustomExtensionsFilter extensions: aCollectionOfExtensions)
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> extensions: aCollectionOfExtensions named: aString [

	self filter: (StFBCustomExtensionsFilter
			 extensions: aCollectionOfExtensions
			 basename: aString)
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> fileNavigationSystem [
	^ fileNavigationSystem
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> fileReferenceTable [
	^ fileNavigationSystem fileReferenceTable
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> filter [
	^ filter
		ifNil: [ filter := StFBVisibleFilter new ]
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> filter: aStFBFilter [

	filter := aStFBFilter.
	fileNavigationSystem ifNotNil: [ fileNavigationSystem filter: filter ]
]

{ #category : 'utilities' }
StFBFileDialogPresenter >> iconFor: anEntry [

	| ext |
	anEntry isDirectory ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		  at: ext
		  ifPresent: [ :icon | icon ]
		  ifAbsent: [ self iconNamed: #page ]
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initialize [

	super initialize.
	okAction := OkAction.
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initializeBookmarksTreeTable [

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
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ];
		expandRoots
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initializeConfirmButton: aButton [

	| buttonEnableBlock |
	self allowsChooseDirectoryIfNoFilename ifTrue: [ ^ self ].
	buttonEnableBlock := [ :newText | 
	                     aButton enabled: newText trimmed isNotEmpty ].
	fileNavigationSystem nameText whenTextChangedDo: buttonEnableBlock.
	buttonEnableBlock value: fileNavigationSystem nameText text
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	| confirmButton |
	aDialogWindowPresenter
		okAction: [ 
			self selectedEntry ifNotNil: [ :entry | 
					aDialogWindowPresenter beOk.
					aDialogWindowPresenter close.
					self confirmed ] ];
		cancelAction: #close;
		addButton: self cancelLabel do: #triggerCancelAction.
	confirmButton := aDialogWindowPresenter
		                 addButton: self confirmLabel
		                 do: #triggerOkAction.
	self initializeConfirmButton: confirmButton
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initializePresenters [

	bookmarksTreeTable := self newTreeTable.
	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter on: self model.
	fileNavigationSystem filter: self filter.

	self initializeBookmarksTreeTable
]

{ #category : 'initialization' }
StFBFileDialogPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: 1050 @ 750
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : 'api - customization' }
StFBFileDialogPresenter >> isolate [
	self bookmarks: self bookmarks copy.
	
]

{ #category : 'api - customization' }
StFBFileDialogPresenter >> okAction: aOneArgBlock [
	okAction := aOneArgBlock
]

{ #category : 'opening' }
StFBFileDialogPresenter >> open [

	^ self openDialog
]

{ #category : 'opening' }
StFBFileDialogPresenter >> openModal [

	super openModal cancelled ifTrue: [ ^ nil ].
	^ self selectedEntry
]

{ #category : 'api - customization' }
StFBFileDialogPresenter >> previewer: aPreviewer [ 
	fileNavigationSystem previewer: aPreviewer
]

{ #category : 'utilities' }
StFBFileDialogPresenter >> selectFile: aFile [

	fileNavigationSystem selectedEntry = aFile ifFalse: [ 
		fileNavigationSystem fileReferenceTable selectIndex:
			(fileNavigationSystem fileReferenceTable items indexOf: aFile) ].
	fileNavigationSystem nameText text: aFile basename
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> selectedEntry [

	| entry |
	entry := fileNavigationSystem selectedEntry.
	(self allowsChooseDirectoryIfNoFilename not and: [ 
		 entry exists and: [ entry isDirectory ] ]) ifTrue: [ 
		self inform: 'Only files could be selected (no directories)'.
		^ nil ].
	^ entry
]

{ #category : 'accessing' }
StFBFileDialogPresenter >> showDirectory: aFileReference [

	fileNavigationSystem currentDirectory: aFileReference
]
