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
	#name : #FDFileDialogPresenter,
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
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #icons }
FDFileDialogPresenter class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: FDFileDialogPresenter class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : #commander2 }
FDFileDialogPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: FDRemoveBookmarkCommand forSpec;
				yourself)
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | fileReference ]
]

{ #category : #specs }
FDFileDialogPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 200;
		add: #bookmarksTreeTable;
		add: #fileNavigationSystem;
		yourself
]

{ #category : #examples }
FDFileDialogPresenter class >> exampleBookmark [
	<example>
	| presenter |
	presenter := FDOpenFileDialog new.
	"this is a flat example"
	presenter
		bookmarks:
			{FDBookmark home.
			FDBookmark root.
			FDBookmark tmp.
			(FDBookmark
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
FDFileDialogPresenter class >> examplePreviewer [
	| presenter |
	presenter := FDOpenFileDialog new.
	presenter previewer: FDInspectPreviewer new.
	presenter openDialogWithSpec.
	^ presenter
]

{ #category : #example }
FDFileDialogPresenter class >> exampleSaveDialog [
	<example>
		^ FDSaveFileDialog new openDialogWithSpec 
]

{ #category : #example }
FDFileDialogPresenter class >> exampleSaveFileDialog [
	^ FDSaveFileDialog new openDialogWithSpec
]

{ #category : #example }
FDFileDialogPresenter class >> fullExample [
	<example>
	| presenter |
	presenter := FDOpenFileDialog new.
	
	presenter previewer: FDContentPreviewer new.	
	"with this when you select a png file it will display it"
	
	presenter filtersCustomization: {FDPNGFilter new}.
	"with you add filter and there always the 'no filter'"
	
	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"
	
	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "
	
	presenter
		bookmarks:
			{(FDGroupBookmark
				name: 'exampleGroup'
				collection:
					{FDBookmark image.
					FDBookmark home}
				iconName: 'group')} .
	"you define the bookmarks have to be instance of FDAbstractBookMark"
	
	presenter columns:  { FDCreationDateColumn }. 
	
	presenter inspect.
	presenter openModalWithSpec.
	^ presenter confirm
]

{ #category : #icons }
FDFileDialogPresenter class >> imageIcons [
	<icons>
	^ {(#png -> (self iconNamed: #komitter)).
	(#jpg -> (self iconNamed: #komitter)).
	(#gif -> (self iconNamed: #komitter)).
	(#svg -> (self iconNamed: #komitter))}
]

{ #category : #'class initialization' }
FDFileDialogPresenter class >> initialize [
	OkAction := self defaultOkActionBlock.
	Bookmarks := FDBookmark defaultBookmarks
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> open [
	^ self new
		openDialogWithSpec;
		yourself
]

{ #category : #icons }
FDFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
	(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #accessing }
FDFileDialogPresenter >> bookmarks [
	^ bookmarks
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> bookmarks: aCollectionOfFDGroupBookMark [
	bookmarks := aCollectionOfFDGroupBookMark asOrderedCollection.
	bookmarksTreeTable roots: bookmarks 
]

{ #category : #accessing }
FDFileDialogPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> columns: aCollectionOfColumns [
	fileNavigationSystem columns: aCollectionOfColumns 
]

{ #category : #utilities }
FDFileDialogPresenter >> confirm [
 	 ^self selectedEntry
		ifNotNil: [ :entry | 
			okAction cull: entry.
		 ]
]

{ #category : #initialization }
FDFileDialogPresenter >> connectPresenters [
	bookmarksTreeTable
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ :selectedItem | 
					selectedItem isComposite
						ifFalse: [ fileNavigationSystem openFolder: selectedItem location ] ] ]
]

{ #category : #accessing }
FDFileDialogPresenter >> currentDirectory [
	^ fileNavigationSystem currentDirectory 
]

{ #category : #utilities }
FDFileDialogPresenter >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> defaultFolder: aPath [
	fileNavigationSystem defaultFolder: aPath
]

{ #category : #accessing }
FDFileDialogPresenter >> fileNavigationSystem [
	^ fileNavigationSystem
]

{ #category : #accessing }
FDFileDialogPresenter >> fileReferenceTable [
	^ fileNavigationSystem fileReferenceTable
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> filtersCustomization: aCollection [ 
	fileNavigationSystem filtersCustomization: aCollection
]

{ #category : #utilities }
FDFileDialogPresenter >> iconFor: anEntry [
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
FDFileDialogPresenter >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
FDFileDialogPresenter >> initialize [
	bookmarks := Bookmarks.
	okAction := OkAction.
	super initialize
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeBookmarksTreeTable [
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
FDFileDialogPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	super initializeDialogWindow: aDialogWindowPresenter.
	aDialogWindowPresenter
		title: self initialTitle;
		initialExtent: 900 @ 900;
		okAction: [ self confirm ];
		cancelAction: [ self delete ]
]

{ #category : #initialization }
FDFileDialogPresenter >> initializePresenters [
	bookmarksTreeTable := self newTreeTable.
	fileNavigationSystem := self instantiate: FDFileNavigationSystemPresenter.

	self initializeBookmarksTreeTable.
	self focusOrder
		add: bookmarksTreeTable;
		add: fileNavigationSystem
]

{ #category : #accessing }
FDFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> isolate [
	bookmarks := bookmarks copy.
	
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> okAction: aOneArgBlock [
	okAction := aOneArgBlock
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> previewer: aPreviewer [ 
	fileNavigationSystem previewer: aPreviewer
]

{ #category : #utilities }
FDFileDialogPresenter >> selectFile: aFile [
	fileNavigationSystem selectedEntry = aFile
		ifFalse: [ fileNavigationSystem fileReferenceTable
				selectIndex: (fileNavigationSystem fileReferenceTable items indexOf: aFile) ].
	fileNavigationSystem nameText text: aFile basename
]

{ #category : #accessing }
FDFileDialogPresenter >> selectedBookMark [
	^ bookmarksTreeTable selection selectedItem
]

{ #category : #accessing }
FDFileDialogPresenter >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #utilities }
FDFileDialogPresenter >> selectedFile [
	^ fileNavigationSystem fileReferenceTable selectedItem
]
