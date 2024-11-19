"
This Spec presenter provides:

* An history of visited folder.
* A text input used to jump to the write path.
* A drop list used to filter the content of the fileReferenceTable
* A text presenter to show a preview of the currently selected file.

## Example

To open a navigation presenter for PNG files, evaluate:

```smalltalk
StFileNavigationSystemPresenter example.
```

## Customization

You can customize how this presenter is displayed, with methods listed at the protocol 'api-customization'. These are some examples:

* `column: aCollectionOfColumn` : Give a `Collection` of any subclass of `StFileBrowserAbstractColumn`.
* `defaultFoler: aFileReference`
* `filtersCustomization: aCollectionOfFilter` : See `StFileBrowserAbstractFilter` on tge avaiable filters and how to instantiate them.
* `previewer: aPreviewer` : See `StFileBrowserAbstractPreviewer` to check the available previewers.
	
## Instance variables

* currentPathTextInputPresenter : <SpTextInputFieldPresenter> It's use to display the current path and there are same feature like in window 
* nameLabel : <SpLabelPresenter>
* nameText: <SpTextInputFieldPresenter> , use to show the name of the selected item of fileReferenceTable
* filtersDropList <SpDropList> , use to display all the filter
* readPointerHistoryParcour <DoubleLink> , use for the navigationSystem
* currentDirectory , <FileReference> into there is the currentDirectory 
* hiddenFilter <FDAbstractPredicate> there is a NullFilter or an hiddenFilter
* columns <FDAbstractFileReferenceColumn> it's a collection of Column use by FileReferenceTable
* previewer <FDAbstractPreviewer> 
* nextButton <SpButton> use for the navigationSystem 
* previousButton <SpButton> use for the navigationSystem
* notebookPreviewer <SpNoteBook> use by the preview system
* fileReferenceTable <SpTablePresenter> it's display children of the current directory
"
Class {
	#name : 'StFileNavigationSystemPresenter',
	#superclass : 'StFileBrowserAbstractPresenter',
	#instVars : [
		'nameText',
		'filtersDropList',
		'filter',
		'previewer',
		'nextButton',
		'previousButton',
		'notebookPreviewer',
		'fileReferenceTable',
		'configButton',
		'pathBreadcrumbPresenter',
		'newFolderButton',
		'showPreview'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'commands' }
StFileNavigationSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'StFileBrowserNavigationMenu') asSpecGroup
				register: StFileBrowserNewDirectoryCommand forSpec;
				register: StFileBrowserCopyBasenameCommand forSpec;
				register: StFileBrowserCopyFullnameCommand forSpec;				
				
				register: StFileBrowserRenameCommand forSpec;
				register: StFileBrowserRemoveCommand forSpec;
				register: StFileBrowserInspectCommand forSpec;
				register: StFileBrowserCompressCommand forSpec;
				register: StFileBrowserFileInCommand forSpec;
				register: StFileBrowserChangeListCommand forSpec;
				register: StFileBrowserOpenTerminalCommand forSpec;

				register:
					((CmCommandGroup named: 'Bookmarks') asSpecGroup
						register: StFileBrowserAddBookmarkCommand forSpec;
						yourself);
				register: StFileBrowserToggleHiddenFilesCommand forSpec;
				yourself)
]

{ #category : 'examples' }
StFileNavigationSystemPresenter class >> example [
	<example>
	| presenter |
	presenter := self new.
	
	presenter previewer: StFileBrowserPNGPreviewer new.
	presenter open.
	presenter inspect.
	^ presenter
]

{ #category : 'api' }
StFileNavigationSystemPresenter >> beMultipleSelection [
	
	self fileReferenceTable 
		beMultipleSelection
]

{ #category : 'api - customization' }
StFileNavigationSystemPresenter >> columns: aCollectionOfColumns [
	| tmpColumn |
	tmpColumn := aCollectionOfColumns asSet.
	tmpColumn
		addAll:
			({StFileBrowserIconColumn.
			StFileBrowserNameColumn} ).
	fileReferenceTable
		columns: ((tmpColumn asOrderedCollection sort: #priority ascending) collect: #column)
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> configButtonAction [

	configButton action: [
		SettingBrowser new
			rootNodes: (SettingBrowser currentTree nodeNamed: #fileBrowser) allChildren;
			open ].
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> connectPresenters [

	self filesListAction.
	self nameTextAction.
	self filtersDropListAction.
	self previousBeforeButtonAction.
	self nextButtonAction.
	self configButtonAction.
	newFolderButton action: [ self createDirectory ]
]

{ #category : 'utilities' }
StFileNavigationSystemPresenter >> currentDirectoryChildren [

	^ [ self currentDirectory children select: #exists ]
		  on: Error
		  do: [ #(  ) ]
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> defaultFileSortBlock [

	^ [:entry1 :entry2 |
		entry1 isDirectory = entry2 isDirectory
			ifTrue: [entry1 basename caseInsensitiveLessOrEqual: entry2 basename]
			ifFalse: [entry1 isDirectory
						ifTrue: [true]
						ifFalse: [entry2 isDirectory
									ifTrue: [false]
									ifFalse: [entry1 basename caseInsensitiveLessOrEqual: entry2 basename]]]]
]

{ #category : 'api - customization' }
StFileNavigationSystemPresenter >> defaultFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	self initializeHistoryIteratorWith: aFileReference
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> defaultLayout [

	| filesLayout |
	filesLayout := self showPreview
		               ifTrue: [
			               SpPanedLayout newTopToBottom
				               add: self topPaneLayout;
				               add: notebookPreviewer;
				               yourself ]
		               ifFalse: [
			               SpBoxLayout newTopToBottom
				               add: self topPaneLayout;
				               yourself ].
	^ SpBoxLayout newTopToBottom
		  add: self navigationLayout expand: false;
		  add: filesLayout;
		  yourself
]

{ #category : 'defaults' }
StFileNavigationSystemPresenter >> defaultPreviewer [

	^ StFileBrowserAdaptiveContentPreviewer new
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> defaultShowPreview [
	"The default value is managed by the global file browser settings"

	^ StFileBrowserSettings showPreview
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> fileNameLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 2;	
		vAlignCenter;
		add: nameText;
		add: filtersDropList expand: false;
		yourself
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> fileReferenceTable [

	^ fileReferenceTable
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> filesListAction [

	| previewProcess |

	fileReferenceTable whenActivatedDo: [ :selectedItem | 
		previewProcess ifNotNil: [ 
			previewProcess isTerminated ifFalse: [ previewProcess terminate ] ].
		selectedItem selectedItem isDirectory
			ifTrue: [ self openFolder: selectedItem selectedItem ] ].

	fileReferenceTable whenSelectedDo: [ :aFileReference | 
		previewProcess ifNotNil: [ previewProcess isTerminated ifFalse: [ previewProcess terminate ] ].
		previewProcess := [ notebookPreviewer pageContent: (self previewer previewOn: aFileReference) ]
				forkAt: Processor userBackgroundPriority
				named: self previewProcessName ]

]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> filter: aFilter [

	filter := aFilter.
	filtersDropList ifNotNil: [ 
		filtersDropList listSize isZero ifFalse: [ 
			self initializeFiltersDropList ] ]
]

{ #category : 'api - customization' }
StFileNavigationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: StAllFilter new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectIndex:
			((filtersDropList listItems collect: #name)
				indexOf: StAllFilter new name)
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> filtersDropListAction [
	filtersDropList whenSelectionChangedDo: [ self updateFileReferenceTable ]
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initialize [

	filter := StAllFilter new.
	super initialize
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initializeFilesTable [

	fileReferenceTable := self newTable.
	fileReferenceTable
		beResizable;
		columns: StFileBrowserAbstractColumn columns;
		sortingBlock: self defaultFileSortBlock;
		whenSelectedItemChangedDo: [ : selectedItem | 
			selectedItem ifNotNil: [ self nameText: selectedItem basename ] ];		
		contextMenuFromCommandsGroup: [ self rootCommandsGroup / 'StFileBrowserNavigationMenu' ]
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initializeFiltersDropList [

	filtersDropList
		items: (StFileBrowserAbstractFilter defaultFiltersWith: filter);
		display: [ :item | item name ];
		selectItem: filter
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initializeNavigationPresenters [

	previousButton := self newButton.
	nextButton := self newButton.

	nextButton
		icon: (self application iconNamed: #forward);
		help: 'See folder you viewed previously.';
		addStyle: 'small'.
	previousButton
		icon: (self application iconNamed: #back);
		help: 'See folder you viewed previously';
		addStyle: 'small'.

]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initializePresenters [

	super initializePresenters.
	notebookPreviewer := self instantiate: StNoteBookPreviewerPresenter.
	pathBreadcrumbPresenter := self instantiate: StPathBreadcrumbPresenter on: self model.
	nameText := self newTextInput.
	filtersDropList := self newDropList.

	self initializeToolbarButtons.	
	self initializeNavigationPresenters.
	self initializeFilesTable.
	self initializeFiltersDropList.
	self openOnLastDirectory 
		ifTrue: [ self updateWidgetWithFileReference: self lastVisitedDirectory ]
		ifFalse: [ self updateWidgetWithFileReference: self defaultDirectory ].
	self initializeHistoryIteratorWith: self currentDirectory
]

{ #category : 'initialization' }
StFileNavigationSystemPresenter >> initializeToolbarButtons [

	newFolderButton := self newButton
			addStyle: 'small';
			help: 'New Folder';
			icon: (self iconNamed: #add);
			yourself.
	configButton := self newButton
			addStyle: 'small';
			help: 'Settings';
			icon: (self iconNamed: #configuration);
			yourself.
]

{ #category : 'testing' }
StFileNavigationSystemPresenter >> isMultipleSelection [

	^ fileReferenceTable isMultipleSelection
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> nameText [
	^ nameText
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> nameText: aString [
	"Set the receive's name text to aString. This is displayed in a text presenter to display the currently selected file, or the name of a new file to be saved"
	
	nameText text: aString.
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> nameTextAction [

	nameText whenTextChangedDo: [ :newText | 
		self nameTextChanged: newText ]
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> nameTextChanged: aText [

	fileReferenceTable selectedItem ifNotNil: [ :item | 
		(item basename = aText or: [ item basenameWithoutExtension = aText ]) 
			ifTrue: [ ^ self ] ].
	fileReferenceTable items
		detect: [ :item | 
			item basename = aText or: [ item basenameWithoutExtension = aText ] ]
		ifFound: [ :item | fileReferenceTable selectItem: item ]
		ifNone: [ fileReferenceTable unselectAll ]
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> navigationLayout [

	^ SpBoxLayout newLeftToRight
		  vAlignCenter;
		  add: previousButton expand: false;
		  add: nextButton expand: false;
		  add: pathBreadcrumbPresenter expand: false;
		  addLast: newFolderButton;
		  addLast: configButton;
		  yourself
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> nextButton [
	^ nextButton
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> nextButtonAction [
	nextButton action: [ self history redoIfEmpty: [ self inform: 'Nothing to redo.' ] ]
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> notebookPreviewer [
	^ notebookPreviewer
]

{ #category : 'utilities' }
StFileNavigationSystemPresenter >> openFolder: aFileReference [

	self updateWidgetWithFileReference: aFileReference.
	model openFolder: aFileReference.
	self owner updateTreeNavigationWithFileReference: aFileReference.

]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> pathBreadcrumbPresenter [
	^ pathBreadcrumbPresenter
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> previewProcessName [

	^ 'File Browser preview loader'
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> previewer [
	"Answer the receiver's previewer, a subclass instance of <StFileBrowserAbstractPreviewer>"

	^ previewer
		ifNil: [ previewer := self defaultPreviewer ]
]

{ #category : 'api - customization' }
StFileNavigationSystemPresenter >> previewer: aPreviewer [ 
	previewer := aPreviewer 
]

{ #category : 'actions' }
StFileNavigationSystemPresenter >> previousBeforeButtonAction [
	previousButton action: [ self history undoIfEmpty: [ self inform: 'Nothing to undo' ] ]
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> previousButton [
	^ previousButton
]

{ #category : 'menu - accessing' }
StFileNavigationSystemPresenter >> selectEntries: aCollection [
	"Set a <Collection> of <FileReference> representing user's selections"
	
	self fileReferenceTable selectItems: aCollection
]

{ #category : 'menu - accessing' }
StFileNavigationSystemPresenter >> selectedEntries [
	"Answer a <Collection> of <FileReference> representing user's selections"
	
	^ self fileReferenceTable selectedItems
]

{ #category : 'accessing' }
StFileNavigationSystemPresenter >> selectedEntry [
	"Answer a <FileReference> representing the current selection. If there is no selection, answer the current directory"
	^ fileReferenceTable selection selectedItem 
		ifNil: [ 	self currentDirectory ]
]

{ #category : 'asserting' }
StFileNavigationSystemPresenter >> shouldReparent [
	"Since a removal was requested from the navigation table, is not necessary to move to the parent directory"

	^ false
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> showPreview [
	"Answer <true> if receiver should display a preview presenter"
	
	^ showPreview
		ifNil: [ showPreview := self defaultShowPreview ]
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> showPreview: aBoolean [
	"Set the enabled preview to aBoolean"
	
	showPreview := aBoolean
]

{ #category : 'layout' }
StFileNavigationSystemPresenter >> topPaneLayout [

	^ SpBoxLayout newTopToBottom
		add: fileReferenceTable;
		add: self fileNameLayout expand: false fill: false padding: 1;
		yourself
]

{ #category : 'utilities' }
StFileNavigationSystemPresenter >> updateFileReferenceTable [
	"Update the receiver's contents according to the current directory and apply configured filters"

	| items |
	
	items := (filtersDropList selectedItem ifNil: [ filter ]) applyOn: self currentDirectoryChildren.
	StFileBrowserSettings showHiddenFiles ifFalse: [ items := items reject: [ :file | file isHidden ] ].
	fileReferenceTable items: items
]

{ #category : 'accessing - history' }
StFileNavigationSystemPresenter >> updateWidgetWithFileReference: aFileReference [
	"A file reference was selected in the receiver or one of its subpresenters, update the file reference table and current directory"

	self currentDirectory: aFileReference.
	self updateFileReferenceTable.
	pathBreadcrumbPresenter 
		currentDirectory: self currentDirectory;
		updatePathSelection: aFileReference.
	
]
