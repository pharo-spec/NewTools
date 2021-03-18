"
I'm use by thez fileDialog

my job is to navigate across file 

I provide:
* an history of visited folder
* a textInput use to jump to the write path
* a dropList use to filter the content of the fileReferenceTable
* a TextPresenter to show the selectedFile 

CUSTOMIZATION
-------------

look at the protocol 'api-customization'

column: aCollectionOfColumn
===========================

	to use it you have to give a collection of son of FDAbstractFileReferenceColumn for more information on how to create see documentation of FDAbstractFileReferenceColumn

defaultFoler: aFileReference
============================

	nothing to say 

filtersCustomization: aCollectionOfFilter
=========================================

	more documentation see FDAbstractPredicate documentation

previewer: aPreviewer
=====================

	more documentation see FDAbstractPreviewer documentation
	
IV
--

currentPathTextInputPresenter : <SpTextInputFieldPresenter> It's use to display the current path and there are same feature like in window 
nameLabel : <SpLabelPresenter>
nameText: <SpTextInputFieldPresenter> , use to show the name of the selected item of fileReferenceTable
filtersDropList <SpDropList> , use to display all the filter
readPointerHistoryParcour <DoubleLink> , use for the navigationSystem
currentDirectory , <FileReference> into there is the currentDirectory 
hiddenFilter <FDAbstractPredicate> there is a NullFilter or an hiddenFilter
columns <FDAbstractFileReferenceColumn> it's a collection of Column use by FileReferenceTable
previewer <FDAbstractPreviewer> 
nextButton <SpButton> use for the navigationSystem 
previousButton <SpButton> use for the navigationSystem
notebookPreviewer <SpNoteBook> use by the preview system
fileReferenceTable <SpTablePresenter> it's display children of the current directory
"
Class {
	#name : #StFBFileNavigationSystemPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'currentPathTextInputPresenter',
		'nameText',
		'filtersDropList',
		'currentDirectory',
		'hiddenFilter',
		'previewer',
		'nextButton',
		'previousButton',
		'notebookPreviewer',
		'fileReferenceTable',
		'history'
	],
	#classVars : [
		'LastVisitedDirectory',
		'Previewer'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #commands }
StFBFileNavigationSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: StFBNewFolderCommand forSpec;
				register: StFBToggleHiddenFilesCommand forSpec;
				register: StFBInspectCommand forSpec;
				register:
					((CmCommandGroup named: 'Bookmarks') asSpecGroup
						register: StFBAddBookmarkCommand forSpec;
						yourself);
				yourself)
]

{ #category : #defaults }
StFBFileNavigationSystemPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory
]

{ #category : #defaults }
StFBFileNavigationSystemPresenter class >> defaultPreviewer [
	^ StFBNullPreviewer new
]

{ #category : #specs }
StFBFileNavigationSystemPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		add:
			(SpBoxLayout newLeftToRight
				add: #previousButton expand: false;
				add: #nextButton expand: false;
				add: #currentPathTextInputPresenter;
				yourself)
			 expand: false;
		add:
			(SpPanedLayout newTopToBottom
				add: #fileReferenceTable;
				add: #notebookPreviewer;
				yourself);
		add:
			(SpBoxLayout newLeftToRight
				add: #nameText;
				add: #filtersDropList expand: false;
				yourself)
			 expand: false;
		yourself
]

{ #category : #examples }
StFBFileNavigationSystemPresenter class >> example [
	<example>
	| presenter |
	presenter := self new.
	"presenter defaultFolder: FileLocator documents."
	presenter previewer: StFBPNGPreviewer new.
	presenter openWithSpec.
	presenter inspect.
	^ presenter
]

{ #category : #'class initialization' }
StFBFileNavigationSystemPresenter class >> initialize [
	Previewer := self defaultPreviewer
]

{ #category : #defaults }
StFBFileNavigationSystemPresenter class >> lastVisitedDirectory [
	^ (LastVisitedDirectory isNil or: [ LastVisitedDirectory exists not ])
		ifTrue: [ LastVisitedDirectory := self defaultDirectory ]
		ifFalse: [ LastVisitedDirectory ]
]

{ #category : #'api-customization' }
StFBFileNavigationSystemPresenter >> columns: aCollectionOfColumns [
	| tmpColumn |
	tmpColumn := aCollectionOfColumns asSet.
	tmpColumn
		addAll:
			({StFBIconColumn.
			StFBNameColumn} ).
	fileReferenceTable
		columns: ((tmpColumn asOrderedCollection sort: #priority ascending) collect: #column)
]

{ #category : #initialization }
StFBFileNavigationSystemPresenter >> connectPresenters [
	self filesListAction.
	self filtersDropListAction.
	self currentPathTextInputAction.
	self previousBeforeButtonAction.
	self nextButtonAction
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> createDirectory: initialName [
	| name path |
	name := (UIManager default
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder') ifNil: [ ^ self ].
	path := currentDirectory / name.
	path exists
		ifFalse: [ (currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ UIManager default alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ UIManager default alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> currentDirectory [ 
	^ currentDirectory
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> currentDirectory: aFileReference [
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : #'initialize-actions' }
StFBFileNavigationSystemPresenter >> currentPathTextInputAction [

	currentPathTextInputPresenter entityText 
		whenSubmitDo: [ :text | 
			text asFileReference exists
				ifFalse: [ 
					self inform: 'you have to write an absolute path and an existing one' ]
				ifTrue: [ 
					self openFolder: text asFileReference ] ]
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : #initialization }
StFBFileNavigationSystemPresenter >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : #'api-customization' }
StFBFileNavigationSystemPresenter >> defaultFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	self initializeHistoryIteratorWith: aFileReference
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> fileReferenceTable [
	^ fileReferenceTable
]

{ #category : #'initialize-actions' }
StFBFileNavigationSystemPresenter >> filesListAction [

	fileReferenceTable
		transmitTo: nameText
		transform: [ :selectedItem | 
			selectedItem 
				ifNotNil: [ selectedItem basename ]
				ifNil: [ '' ] ].
	
	fileReferenceTable
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ self openFolder: selectedItem selectedItem ] ].
	fileReferenceTable
		whenSelectionChangedDo: [ :aFileReference | 
			notebookPreviewer
				page: (previewer previewOn: aFileReference selectedItem) ]
]

{ #category : #'api-customization' }
StFBFileNavigationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: StFBNilFilter new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: StFBNilFilter new name)
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #'initialize-actions' }
StFBFileNavigationSystemPresenter >> filtersDropListAction [
	filtersDropList whenSelectionChangedDo: [ self updateTableContent ]
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> hiddenFilter [
	^ hiddenFilter
]

{ #category : #initialization }
StFBFileNavigationSystemPresenter >> initialize [
	hiddenFilter := StFBVisibleFilter new.
	previewer := Previewer.
	super initialize
]

{ #category : #'initialize-widgets' }
StFBFileNavigationSystemPresenter >> initializeFilesTable [
	fileReferenceTable
		beResizable;
		columns: StFBAbstractColumn columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not or: [ a isDirectory & b isDirectory & (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile & (a basename asLowercase < b basename asLowercase) ] ];
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ]
]

{ #category : #'initialize-widgets' }
StFBFileNavigationSystemPresenter >> initializeFiltersDropList [
	
	filtersDropList
		items: StFBAbstractFilter defaultFilters;
		display: [ :item | item name ];
		selectIndex: 1
]

{ #category : #initialization }
StFBFileNavigationSystemPresenter >> initializeHistoryIteratorWith: aFolder [
	history := ConfigurableHistoryIterator
		undo: [ :folder | history hasPrevious
			ifTrue: [ self updateWidgetWithFileReference: history current ]
			ifFalse: [ self inform: 'Nothing to undo' ] ]
		redo: [ :folder | self updateWidgetWithFileReference: folder ].
	history register: aFolder
]

{ #category : #initialization }
StFBFileNavigationSystemPresenter >> initializePresenters [
	notebookPreviewer := self instantiate: StFBNoteBookPreviewerPresenter.
	fileReferenceTable := self newTable.
	currentPathTextInputPresenter := self instantiate: StFBWindowPathPresenter.
	nameText := self newTextInput.
	filtersDropList := self newDropList.
	previousButton := self newButton.
	nextButton := self newButton.

	nextButton icon: (self iconNamed: #glamorousDiveRight).
	previousButton icon: (self iconNamed: #back).
	nameText autoAccept: true.
	self initializeFilesTable.
	self initializeFiltersDropList.
	self updateWidgetWithFileReference: self lastVisitedDirectory.
	self initializeHistoryIteratorWith: currentDirectory.

	self focusOrder
		add: previousButton;
		add: nextButton;
		add: currentPathTextInputPresenter;
		add: fileReferenceTable;
		add: nameText;
		add: filtersDropList
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> lastVisitedDirectory [
	^ self class lastVisitedDirectory
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> nameText [
	^ nameText
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> nextButton [
	^ nextButton
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> nextButtonAction [
	nextButton action: [ history redoIfEmpty: [ self inform: 'Nothing to redo.' ] ]
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> notebookPreviewer [
	^ notebookPreviewer
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> openFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	history register: currentDirectory
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> previewer [
	^ previewer
]

{ #category : #'api-customization' }
StFBFileNavigationSystemPresenter >> previewer: aPreviewer [ 
	previewer := aPreviewer 
]

{ #category : #'initialize-actions' }
StFBFileNavigationSystemPresenter >> previousBeforeButtonAction [
	previousButton action: [ history undoIfEmpty: [ self inform: 'Nothing to undo' ] ]
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> previousButton [
	^ previousButton
]

{ #category : #accessing }
StFBFileNavigationSystemPresenter >> selectedEntry [
	^ fileReferenceTable selection selectedItem
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> toggleHiddenFiles [
	(hiddenFilter equals: StFBNilFilter  new)
		ifTrue: [ hiddenFilter := StFBVisibleFilter new ]
		ifFalse: [ hiddenFilter := StFBNilFilter new ].
	self updateTableContent
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> updateTableContent [
	fileReferenceTable
		items:
			(hiddenFilter
				applyOn: (filtersDropList selectedItem applyOn: currentDirectory children))
]

{ #category : #utilities }
StFBFileNavigationSystemPresenter >> updateWidgetWithFileReference: aFileReference [
	self currentDirectory: aFileReference.
	self updateTableContent.
	currentPathTextInputPresenter currentDirectory: currentDirectory
]
