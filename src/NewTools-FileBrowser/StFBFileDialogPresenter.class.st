"
I am an abstract base class for different styles of opening/saving.




## author 

main Author : peteruhnak
Migrator Spec 1 to Spec 2 : CafeKrem (github pseudo)
if you have question please send me a mail : dutriezcle@gmail.com

## Examples

|------------------------------------------|
				look at this method 
|---> FDFileDialogPresenter fullExample <--|
|------------------------------------------|

see class-side

## Website

https://github.com/peteruhnak/file-dialog

## HOW TO RUN 

FDOpenFileDialog open
open is define in FDFileDialogPresenter class side 
Don't use me directly -- instead use one of my children.

## CUSTOMIZATION 

I define some method to customize your son of FileDialogPresenter

whenSelected: aBlock 
	this method is use to define the action of the accept button
		
filtersCustomization: aCollection 
	this method is use to define a set of Filter (choose one or more among FDAbstractPredicate son or creat a new  predicate)
	THERE IS ALWAYS THE DEFAULT FILTER (this filter filterNothing)
	example: 
		
		(FDOpenFileDialog new filtersCustomization: { FDJPGAndPNGPredicate new }) openDialogWithSpec
		
bookmarks: aCollection Of FDAbstractBookMark
	this method will set bookmarks use the class FDAbstractBookMark
		you can create group with FDGroupBookMark or use FDBookMark to create bookmark
		example : 
		
			class side method defaultBookmarks
	  
defaultFolder: aPath
	this method will open tou fileDialog on a aPath , this path must exist and be a directory
	example
		
		(FDOpenFileDialog new defaultFolder: '/home/cdutriez/' asFileReference) openDialogWithSpec 
	
icons
-----
	if you want to add icons you just have to create a method with pragma <icons> and this method have to return an array of association 
	example:
		
		see FDFileDialogPresenter textIcons method 

"
Class {
	#name : #StFBFileDialogPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'bookmarksTreeTable',
		'bookmarks',
		'fileNavigationSystem',
		'okAction'
	],
	#classVars : [
		'Bookmarks',
		'OkAction'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #icons }
StFBFileDialogPresenter class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: StFBFileDialogPresenter class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : #commander2 }
StFBFileDialogPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: StFBRemoveBookmarkCommand forSpec;
				yourself)
]

{ #category : #defaultClassVariable }
StFBFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | fileReference ]
]

{ #category : #specs }
StFBFileDialogPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: 200;
		  add: #bookmarksTreeTable;
		  add: #fileNavigationSystem;
		  yourself
]

{ #category : #examples }
StFBFileDialogPresenter class >> exampleBookmark [
	<example>
	| presenter |
	presenter := StFBOpenFileDialog new.
	"this is a flat example"
	presenter
		bookmarks:
			{StFBBookmark home.
			StFBBookmark root.
			StFBBookmark tmp.
			(StFBBookmark
				name: 'Image location'
				location: FileLocator imageDirectory
				icon: nil)}
			"this is tree example" 	
			"{(FDGroupBookMark
				CreatWithname: 'exampleGroup'
				WithContent:
					{FDBookmark image.
					FDBookmark home}
				withIconName: 'group')}"
]

{ #category : #example }
StFBFileDialogPresenter class >> examplePreviewer [
	| presenter |
	presenter := StFBOpenFileDialog new.
	presenter previewer: StFBInspectPreviewer new.
	presenter openDialogWithSpec.
	^ presenter
]

{ #category : #example }
StFBFileDialogPresenter class >> exampleSaveDialog [
	<example>
		^ StFBSaveFileDialog new openDialogWithSpec 
]

{ #category : #example }
StFBFileDialogPresenter class >> exampleSaveFileDialog [
	^ StFBSaveFileDialog new openDialogWithSpec
]

{ #category : #example }
StFBFileDialogPresenter class >> fullExample [
	<example>
	| presenter |
	presenter := StFBOpenFileDialog new.
	
	presenter previewer: StFBContentPreviewer new.	
	"with this when you select a png file it will display it"
	
	presenter filtersCustomization: {StFBPNGFilter new}.
	"with you add filter and there always the 'no filter'"
	
	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"
	
	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "
	
	presenter
		bookmarks:
			{(StFBGroupBookmark
				name: 'exampleGroup'
				collection:
					{StFBBookmark image.
					StFBBookmark home}
				iconName: 'group')} .
	"you define the bookmarks have to be instance of FDAbstractBookMark"
	
	presenter columns:  { StFBCreationDateColumn }. 
	
	presenter inspect.
	presenter openModalWithSpec.
	^ presenter confirm
]

{ #category : #icons }
StFBFileDialogPresenter class >> imageIcons [
	<icons>
	^ {(#png -> (self iconNamed: #komitter)).
	(#jpg -> (self iconNamed: #komitter)).
	(#gif -> (self iconNamed: #komitter)).
	(#svg -> (self iconNamed: #komitter))}
]

{ #category : #'class initialization' }
StFBFileDialogPresenter class >> initialize [
	OkAction := self defaultOkActionBlock.
	Bookmarks := StFBBookmark defaultBookmarks
]

{ #category : #'instance creation' }
StFBFileDialogPresenter class >> open [
	^ self new
		openDialogWithSpec;
		yourself
]

{ #category : #icons }
StFBFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
	(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #accessing }
StFBFileDialogPresenter >> bookmarks [
	^ bookmarks
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> bookmarks: aCollectionOfFDGroupBookMark [
	bookmarks := aCollectionOfFDGroupBookMark asOrderedCollection.
	bookmarksTreeTable roots: bookmarks 
]

{ #category : #accessing }
StFBFileDialogPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> columns: aCollectionOfColumns [
	fileNavigationSystem columns: aCollectionOfColumns 
]

{ #category : #utilities }
StFBFileDialogPresenter >> confirm [
 	 ^self selectedEntry
		ifNotNil: [ :entry | 
			okAction cull: entry.
		 ]
]

{ #category : #initialization }
StFBFileDialogPresenter >> connectPresenters [
	bookmarksTreeTable
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ :selectedItem | 
					selectedItem isComposite
						ifFalse: [ fileNavigationSystem openFolder: selectedItem location ] ] ]
]

{ #category : #accessing }
StFBFileDialogPresenter >> currentDirectory [
	^ fileNavigationSystem currentDirectory 
]

{ #category : #utilities }
StFBFileDialogPresenter >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> defaultFolder: aPath [
	fileNavigationSystem defaultFolder: aPath
]

{ #category : #accessing }
StFBFileDialogPresenter >> fileNavigationSystem [
	^ fileNavigationSystem
]

{ #category : #accessing }
StFBFileDialogPresenter >> fileReferenceTable [
	^ fileNavigationSystem fileReferenceTable
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> filtersCustomization: aCollection [ 
	fileNavigationSystem filtersCustomization: aCollection
]

{ #category : #utilities }
StFBFileDialogPresenter >> iconFor: anEntry [
	| ext |
	anEntry isDirectory
		ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		at: ext
		ifPresent: [ :icon | icon ]
		ifAbsent: [ self iconNamed: #page ]
]

{ #category : #'initialize-value' }
StFBFileDialogPresenter >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
StFBFileDialogPresenter >> initialize [
	bookmarks := Bookmarks.
	okAction := OkAction.
	super initialize
]

{ #category : #'initialize-widgets' }
StFBFileDialogPresenter >> initializeBookmarksTreeTable [
	bookmarksTreeTable
		addColumn:
			((SpImageTableColumn evaluated: [ :each | each icon ])
				width: 50;
				yourself);
		addColumn: (SpStringTableColumn evaluated: [ :fdGroupBookMark | fdGroupBookMark name ]);
		roots: bookmarks;
		children: #children;
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ]
]

{ #category : #initialization }
StFBFileDialogPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	super initializeDialogWindow: aDialogWindowPresenter.
	aDialogWindowPresenter
		title: self initialTitle;
		initialExtent: 900 @ 900;
		okAction: [ self confirm ];
		cancelAction: [ self delete ]
]

{ #category : #initialization }
StFBFileDialogPresenter >> initializePresenters [
	bookmarksTreeTable := self newTreeTable.
	fileNavigationSystem := self instantiate: StFBFileNavigationSystemPresenter.

	self initializeBookmarksTreeTable.
	self focusOrder
		add: bookmarksTreeTable;
		add: fileNavigationSystem
]

{ #category : #accessing }
StFBFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> isolate [
	bookmarks := bookmarks copy.
	
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> okAction: aOneArgBlock [
	okAction := aOneArgBlock
]

{ #category : #'api-customization' }
StFBFileDialogPresenter >> previewer: aPreviewer [ 
	fileNavigationSystem previewer: aPreviewer
]

{ #category : #utilities }
StFBFileDialogPresenter >> selectFile: aFile [
	fileNavigationSystem selectedEntry = aFile
		ifFalse: [ fileNavigationSystem fileReferenceTable
				selectIndex: (fileNavigationSystem fileReferenceTable items indexOf: aFile) ].
	fileNavigationSystem nameText text: aFile basename
]

{ #category : #accessing }
StFBFileDialogPresenter >> selectedBookMark [
	^ bookmarksTreeTable selection selectedItem
]

{ #category : #accessing }
StFBFileDialogPresenter >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #utilities }
StFBFileDialogPresenter >> selectedFile [
	^ fileNavigationSystem fileReferenceTable selectedItem
]
