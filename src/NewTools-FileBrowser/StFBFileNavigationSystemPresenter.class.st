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
	#name : 'StFBFileNavigationSystemPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'currentPathTextInputPresenter',
		'nameText',
		'filtersDropList',
		'currentDirectory',
		'filter',
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
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commands' }
StFBFileNavigationSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: StFBNewFolderCommand forSpec;
				register: StFBInspectCommand forSpec;
				register:
					((CmCommandGroup named: 'Bookmarks') asSpecGroup
						register: StFBAddBookmarkCommand forSpec;
						yourself);
				yourself)
]

{ #category : 'defaults' }
StFBFileNavigationSystemPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory
]

{ #category : 'specs' }
StFBFileNavigationSystemPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
				vAlignCenter;
				add: #previousButton expand: false;
				add: #nextButton expand: false;
				add: #currentPathTextInputPresenter;
				yourself)
			 expand: false;
		add: (SpPanedLayout newTopToBottom
				add: #fileReferenceTable;
				add: #notebookPreviewer;
				yourself);
		add: (SpBoxLayout newLeftToRight
				vAlignCenter;
				add: #nameText;
				add: #filtersDropList expand: false;
				yourself)
			 expand: false;
		yourself
]

{ #category : 'defaults' }
StFBFileNavigationSystemPresenter class >> defaultPreviewer [
	^ StFBContentPreviewer new
]

{ #category : 'examples' }
StFBFileNavigationSystemPresenter class >> example [
	<example>
	| presenter |
	presenter := self new.
	
	presenter previewer: StFBPNGPreviewer new.
	presenter open.
	presenter inspect.
	^ presenter
]

{ #category : 'class initialization' }
StFBFileNavigationSystemPresenter class >> initialize [
	Previewer := self defaultPreviewer
]

{ #category : 'defaults' }
StFBFileNavigationSystemPresenter class >> lastVisitedDirectory [

	(LastVisitedDirectory isNotNil and: [ 
		 [ LastVisitedDirectory exists ]
			 on: ResolutionRequest
			 do: [ false ] ]) ifFalse: [ 
		LastVisitedDirectory := self defaultDirectory ].
	^ LastVisitedDirectory
]

{ #category : 'api - customization' }
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

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> connectPresenters [

	self filesListAction.
	self nameTextAction.
	self filtersDropListAction.
	self previousBeforeButtonAction.
	self nextButtonAction
]

{ #category : 'utilities' }
StFBFileNavigationSystemPresenter >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : 'utilities' }
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

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> currentDirectory [ 
	^ currentDirectory
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> currentDirectory: aFileReference [

	(aFileReference exists and: [ aFileReference isDirectory ]) ifFalse: [ 
		DirectoryDoesNotExist signalWith: aFileReference ].
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : 'api - customization' }
StFBFileNavigationSystemPresenter >> defaultFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	self initializeHistoryIteratorWith: aFileReference
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> fileReferenceTable [
	^ fileReferenceTable
]

{ #category : 'actions' }
StFBFileNavigationSystemPresenter >> filesListAction [

	| previewProcess |

	fileReferenceTable
		transmitTo: nameText
		transform: [ :selectedItem | 
			selectedItem ifNotNil: [ selectedItem basename ] ifNil: [ '' ] ].

	fileReferenceTable whenActivatedDo: [ :selectedItem | 
		previewProcess ifNotNil: [ 
			previewProcess isTerminated ifFalse: [ previewProcess terminate ] ].
		selectedItem selectedItem isDirectory
			ifTrue: [ self openFolder: selectedItem selectedItem ]
			ifFalse: [ self owner confirm ] ].

	fileReferenceTable whenSelectedDo: [ :aFileReference | 
		previewProcess ifNotNil: [ 
			previewProcess isTerminated ifFalse: [ previewProcess terminate ] ].
		previewProcess := [ 
		                  notebookPreviewer pageContent:
			                  (previewer previewOn: aFileReference) ]
			                  forkAt: Processor userBackgroundPriority
			                  named: 'File Browser preview loader' ]
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> filter: aFilter [

	filter := aFilter.
	filtersDropList ifNotNil: [ 
		filtersDropList listSize isZero ifFalse: [ 
			self initializeFiltersDropList ] ]
]

{ #category : 'api - customization' }
StFBFileNavigationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: StFBAllFilter new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectIndex:
			((filtersDropList listItems collect: #name)
				indexOf: StFBAllFilter new name)
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : 'actions' }
StFBFileNavigationSystemPresenter >> filtersDropListAction [
	filtersDropList whenSelectionChangedDo: [ self updateTableContent ]
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> initialize [

	filter := StFBVisibleFilter new.
	previewer := Previewer.
	super initialize
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> initializeFilesTable [

	fileReferenceTable
		beResizable;
		columns: StFBAbstractColumn columns;
		sortingBlock: [ :a :b | 
			a isDirectory & b isDirectory not or: [ 
					a isDirectory = b isDirectory and: [ 
							a basename asLowercase < b basename asLowercase ] ] ];
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ]
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> initializeFiltersDropList [

	filtersDropList
		items: (StFBAbstractFilter defaultFiltersWith: filter);
		display: [ :item | item name ];
		selectItem: filter
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> initializeHistoryIteratorWith: aFolder [

	history := ConfigurableHistoryIterator
		undo: [ :folder | history hasPrevious
			ifTrue: [ self updateWidgetWithFileReference: history current ]
			ifFalse: [ self inform: 'Nothing to undo' ] ]
		redo: [ :folder | self updateWidgetWithFileReference: folder ].
	history register: aFolder
]

{ #category : 'initialization' }
StFBFileNavigationSystemPresenter >> initializePresenters [

	notebookPreviewer := self instantiate: StFBNoteBookPreviewerPresenter.
	fileReferenceTable := self newTable.
	currentPathTextInputPresenter := self instantiate: StFBWindowPathPresenter.
	nameText := self newTextInput.
	filtersDropList := self newDropList.
	previousButton := self newButton.
	nextButton := self newButton.

	nextButton
		icon: (self application iconNamed: #forward);
		addStyle: 'small'.
	previousButton
		icon: (self application iconNamed: #back);
		addStyle: 'small'.

	self initializeFilesTable.
	self initializeFiltersDropList.
	self updateWidgetWithFileReference: self lastVisitedDirectory.
	self initializeHistoryIteratorWith: currentDirectory
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> lastVisitedDirectory [
	^ self class lastVisitedDirectory
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> nameText [
	^ nameText
]

{ #category : 'actions' }
StFBFileNavigationSystemPresenter >> nameTextAction [

	nameText whenTextChangedDo: [ :newText | 
		self nameTextChanged: newText ]
]

{ #category : 'actions' }
StFBFileNavigationSystemPresenter >> nameTextChanged: aText [

	fileReferenceTable selectedItem ifNotNil: [ :item | 
		(item basename = aText or: [ item basenameWithoutExtension = aText ]) 
			ifTrue: [ ^ self ] ].
	fileReferenceTable items
		detect: [ :item | 
			item basename = aText or: [ item basenameWithoutExtension = aText ] ]
		ifFound: [ :item | fileReferenceTable selectItem: item ]
		ifNone: [ fileReferenceTable unselectAll ]
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> nextButton [
	^ nextButton
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> nextButtonAction [
	nextButton action: [ history redoIfEmpty: [ self inform: 'Nothing to redo.' ] ]
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> notebookPreviewer [
	^ notebookPreviewer
]

{ #category : 'utilities' }
StFBFileNavigationSystemPresenter >> openFolder: aFileReference [

	self updateWidgetWithFileReference: aFileReference.
	history register: currentDirectory
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> previewer [
	^ previewer
]

{ #category : 'api - customization' }
StFBFileNavigationSystemPresenter >> previewer: aPreviewer [ 
	previewer := aPreviewer 
]

{ #category : 'actions' }
StFBFileNavigationSystemPresenter >> previousBeforeButtonAction [
	previousButton action: [ history undoIfEmpty: [ self inform: 'Nothing to undo' ] ]
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> previousButton [
	^ previousButton
]

{ #category : 'accessing' }
StFBFileNavigationSystemPresenter >> selectedEntry [

	^ fileReferenceTable selection selectedItem ifNil: [ 
		  self nameText text trimmed
			  ifEmpty: [ self currentDirectory ]
			  ifNotEmpty: [ :text | self currentDirectory / text ] ]
]

{ #category : 'utilities' }
StFBFileNavigationSystemPresenter >> updateTableContent [

	fileReferenceTable items:
		((filtersDropList selectedItem ifNil: [ filter ]) applyOn:
			 (currentDirectory children select: #exists)).
]

{ #category : 'utilities' }
StFBFileNavigationSystemPresenter >> updateWidgetWithFileReference: aFileReference [

	self currentDirectory: aFileReference.
	self updateTableContent.
	currentPathTextInputPresenter currentDirectory: currentDirectory
]
