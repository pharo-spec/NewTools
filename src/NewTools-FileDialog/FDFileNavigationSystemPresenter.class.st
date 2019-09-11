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
	#name : #FDFileNavigationSystemPresenter,
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
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #commands }
FDFileNavigationSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'Menu') asSpecGroup
				register: FDNewFolderCommand forSpec;
				register: FDToggleHiddenFilesCommand forSpec;
				register: FDInspectCommand forSpec;
				register:
					((CmCommandGroup named: 'Bookmarks') asSpecGroup
						register: FDAddBookmarkCommand forSpec;
						yourself);
				yourself)
]

{ #category : #defaults }
FDFileNavigationSystemPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory
]

{ #category : #defaults }
FDFileNavigationSystemPresenter class >> defaultPreviewer [
	^ FDNullPreviewer new
]

{ #category : #specs }
FDFileNavigationSystemPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #previousButton expand: false fill: false padding: 0;
				add: #nextButton expand: false fill: false padding: 0;
				add: #currentPathTextInputPresenter;
				yourself)
			 expand: false fill: false padding: 0;
		add:
			(SpPanedLayout newVertical
				add: #fileReferenceTable;
				add: #notebookPreviewer;
				yourself);
		add:
			(SpBoxLayout newHorizontal
				add: #nameText;
				add: #filtersDropList expand: false fill: false padding: 0;
				yourself)
			 expand: false fill: false padding: 0;
		yourself
]

{ #category : #examples }
FDFileNavigationSystemPresenter class >> example [
	<example>
	| presenter |
	presenter := self new.
	"presenter defaultFolder: FileLocator documents."
	presenter previewer: FDPNGPreviewer new.
	presenter openWithSpec.
	presenter inspect.
	^ presenter
]

{ #category : #'class initialization' }
FDFileNavigationSystemPresenter class >> initialize [
	Previewer := self defaultPreviewer
]

{ #category : #defaults }
FDFileNavigationSystemPresenter class >> lastVisitedDirectory [
	^ (LastVisitedDirectory isNil or: [ LastVisitedDirectory exists not ])
		ifTrue: [ LastVisitedDirectory := self defaultDirectory ]
		ifFalse: [ LastVisitedDirectory ]
]

{ #category : #'api-customization' }
FDFileNavigationSystemPresenter >> columns: aCollectionOfColumns [
	| tmpColumn |
	tmpColumn := aCollectionOfColumns asSet.
	tmpColumn
		addAll:
			({FDIconColumn.
			FDNameColumn} ).
	fileReferenceTable
		columns: ((tmpColumn asOrderedCollection sort: #priority ascending) collect: #column)
]

{ #category : #initialization }
FDFileNavigationSystemPresenter >> connectPresenters [
	self filesListAction.
	self filtersDropListAction.
	self currentPathTextInputAction.
	self previousBeforeButtonAction.
	self nextButtonAction
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> createDirectory: initialName [
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
FDFileNavigationSystemPresenter >> currentDirectory [ 
	^ currentDirectory
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> currentDirectory: aFileReference [
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : #'initialize-actions' }
FDFileNavigationSystemPresenter >> currentPathTextInputAction [
	currentPathTextInputPresenter entityText 
		whenTextIsAcceptedDo: [ :text | 
			text asFileReference exists
				ifFalse: [ self
						inform: 'you have to write an absolute path and an existing one' ]
				ifTrue: [ self openFolder: text asFileReference ] ]
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : #initialization }
FDFileNavigationSystemPresenter >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : #'api-customization' }
FDFileNavigationSystemPresenter >> defaultFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	self initializeHistoryIteratorWith: aFileReference
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> fileReferenceTable [
	^ fileReferenceTable
]

{ #category : #'initialize-actions' }
FDFileNavigationSystemPresenter >> filesListAction [
	fileReferenceTable
		transmitTo: nameText
		transform: [ :selectedItem | selectedItem basename ].
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
FDFileNavigationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: FDNilFilter new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDNilFilter new name)
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #'initialize-actions' }
FDFileNavigationSystemPresenter >> filtersDropListAction [
	filtersDropList whenSelectionChangedDo: [ self updateTableContent ]
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> hiddenFilter [
	^ hiddenFilter
]

{ #category : #initialization }
FDFileNavigationSystemPresenter >> initialize [
	hiddenFilter := FDVisibleFilter new.
	previewer := Previewer.
	super initialize
]

{ #category : #'initialize-widgets' }
FDFileNavigationSystemPresenter >> initializeFilesTable [
	fileReferenceTable
		beResizable;
		columns: FDAbstractColumn columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not or: [ a isDirectory & b isDirectory & (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile & (a basename asLowercase < b basename asLowercase) ] ];
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'Menu' ]
]

{ #category : #'initialize-widgets' }
FDFileNavigationSystemPresenter >> initializeFiltersDropList [
	filtersDropList
		items: FDAbstractFilter defaultFilters;
		display: [ :item | item name ];
		selectedIndex: 1
]

{ #category : #initialization }
FDFileNavigationSystemPresenter >> initializeHistoryIteratorWith: aFolder [
	history := ConfigurableHistoryIterator
		undo: [ :folder | history hasPrevious
			ifTrue: [ self updateWidgetWithFileReference: history current ]
			ifFalse: [ self inform: 'Nothing to undo' ] ]
		redo: [ :folder | self updateWidgetWithFileReference: folder ].
	history register: aFolder
]

{ #category : #initialization }
FDFileNavigationSystemPresenter >> initializePresenters [
	notebookPreviewer := self instantiate: FDNoteBookPreviewerPresenter.
	fileReferenceTable := self newTable.
	currentPathTextInputPresenter := self instantiate: FDWindowPathPresenter.
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
FDFileNavigationSystemPresenter >> lastVisitedDirectory [
	^ self class lastVisitedDirectory
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> nameText [
	^ nameText
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> nextButton [
	^ nextButton
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> nextButtonAction [
	nextButton action: [ history redoIfEmpty: [ self inform: 'Nothing to redo.' ] ]
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> notebookPreviewer [
	^ notebookPreviewer
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> openFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	history register: currentDirectory
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> previewer [
	^ previewer
]

{ #category : #'api-customization' }
FDFileNavigationSystemPresenter >> previewer: aPreviewer [ 
	previewer := aPreviewer 
]

{ #category : #'initialize-actions' }
FDFileNavigationSystemPresenter >> previousBeforeButtonAction [
	previousButton action: [ history undoIfEmpty: [ self inform: 'Nothing to undo' ] ]
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> previousButton [
	^ previousButton
]

{ #category : #accessing }
FDFileNavigationSystemPresenter >> selectedEntry [
	^ fileReferenceTable selection selectedItem
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> toggleHiddenFiles [
	(hiddenFilter equals: FDNilFilter  new)
		ifTrue: [ hiddenFilter := FDVisibleFilter new ]
		ifFalse: [ hiddenFilter := FDNilFilter new ].
	self updateTableContent
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> updateTableContent [
	fileReferenceTable
		items:
			(hiddenFilter
				applyOn: (filtersDropList selectedItem applyOn: currentDirectory children))
]

{ #category : #utilities }
FDFileNavigationSystemPresenter >> updateWidgetWithFileReference: aFileReference [
	self currentDirectory: aFileReference.
	self updateTableContent.
	currentPathTextInputPresenter currentDirectory: currentDirectory
]
