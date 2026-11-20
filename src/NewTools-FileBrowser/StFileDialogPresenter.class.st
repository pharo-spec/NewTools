"
I am the abstract root of the file dialogs: a file browser with a confirm and a cancel button, answering the entry the user chose. `StFileBrowserAbstractPresenter` describes how the presenters of a dialog are created and work together; here is what I add.

## Responsibility:

- Open as a dialog window, modal (`openModal`) or not (`open`), and evaluate the `okAction:` block with the choice when the user confirms. The open dialogs answer their `selectedEntries` from `openModal`, or nil when cancelled.
- Check the choice before closing (`selectedEntry`, which refuses a folder when the dialog wants a file) and enable the confirm button only when a name is entered.
- Let the code opening me customize the dialog: filter or extensions, columns, previewer, starting folder, title, bookmarks.

## Collaborators:

- `StFileNavigationSystemPresenter`: receives most of the customizations.
- `StFileBrowserAbstractFilter` (`StCustomExtensionsFilter`), `StFileBrowserAbstractColumn`, `StFileBrowserAbstractPreviewer`: the customizations.
- `SpDialogWindowPresenter`: my window, with its buttons.

## Public API and Key Messages

- `MyDialogClass chooseModal`: opens a modal dialog and answers what `openModal` answers.
- `MyDialogClass chooseThenDo: aBlock`: opens a dialog and evaluates aBlock with the choice.
- `extensions: aCollection`, `extensions: aCollection named: aString`, `filter: aFilter`: what files to list.
- `defaultFolder: aFileReference`, `title: aString`, `columns: aCollection`, `previewer: aPreviewer`, `bookmarks: aCollection`.
- `okAction: aOneArgBlock`, `selectedEntry`, `nameText`, `nameText: aString`.

## Examples

```smalltalk
StOpenFilePresenter exampleExtensions.
StSaveFilePresenter example.
```

## Internal Representation

- `okAction`: the block evaluated with the choice, by default answering it.
- `filter`: the filter given to the navigation presenter.
"
Class {
	#name : 'StFileDialogPresenter',
	#superclass : 'StFileSystemPresenter',
	#instVars : [
		'okAction',
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
StFileDialogPresenter class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: StFileDialogPresenter class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : 'examples' }
StFileDialogPresenter class >> chooseModal [

	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	^ self new openModal
]

{ #category : 'examples' }
StFileDialogPresenter class >> chooseModalAndInspect [

	^ self chooseModal inspect
]

{ #category : 'examples' }
StFileDialogPresenter class >> chooseModalIfNone: aBlock [

	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	^ self chooseModal ifNil: aBlock
]

{ #category : 'examples' }
StFileDialogPresenter class >> chooseThenDo: aBlock [
	"Return selected item immediately (blocking/modal). Returns nil if no valid item selected"

	<example>
	^ (self on: StFileSystemModel new)
		  okAction: aBlock;
		  open
]

{ #category : 'examples' }
StFileDialogPresenter class >> chooseThenInspect [

	^ self chooseThenDo: [ :file | file inspect ]
]

{ #category : 'defaultClassVariable' }
StFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | fileReference ]
]

{ #category : 'accessing' }
StFileDialogPresenter class >> defaultPreferredExtent [ 

	^ (1050 @ 750)
]

{ #category : 'accessing - Class' }
StFileDialogPresenter class >> extensions: aCollectionOfExtensions [

	^ self new
		  extensions: aCollectionOfExtensions;
		  openDialog;
		  yourself
]

{ #category : 'accessing - Class' }
StFileDialogPresenter class >> extensions: aCollectionOfExtensions named: aString [

	^ self new
		  extensions: aCollectionOfExtensions named: aString;
		  openDialog;
		  yourself
]

{ #category : 'class initialization' }
StFileDialogPresenter class >> initialize [

	Bookmarks := OrderedCollection new.
	OkAction := self defaultOkActionBlock.

]

{ #category : 'icons' }
StFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
	(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : 'hooks' }
StFileDialogPresenter >> allowsChooseDirectoryIfNoFilename [

	^ false
]

{ #category : 'accessing - ui' }
StFileDialogPresenter >> cancelLabel [

	^ 'Cancel'
]

{ #category : 'testing' }
StFileDialogPresenter >> cancelled [

	^ self withWindowDo: [ :w | w cancelled ]
]

{ #category : 'api - customization' }
StFileDialogPresenter >> columns: aCollectionOfColumns [

	self fileNavigationSystem columns: aCollectionOfColumns 
]

{ #category : 'actions' }
StFileDialogPresenter >> confirm [

	^ self withWindowDo: [ :window |
		 window triggerOkAction ]
]

{ #category : 'accessing - ui' }
StFileDialogPresenter >> confirmLabel [

	^ 'Accept'
]

{ #category : 'actions' }
StFileDialogPresenter >> confirmed [

	^ okAction cull: self selectedEntry
]

{ #category : 'api - customization' }
StFileDialogPresenter >> defaultFolder: aPath [
	self fileNavigationSystem defaultFolder: aPath
]

{ #category : 'accessing' }
StFileDialogPresenter >> extensions: aCollectionOfExtensions [

	self filter: (StCustomExtensionsFilter extensions: aCollectionOfExtensions)
]

{ #category : 'accessing' }
StFileDialogPresenter >> extensions: aCollectionOfExtensions named: aString [

	self filter: (StCustomExtensionsFilter
			 extensions: aCollectionOfExtensions
			 basename: aString)
]

{ #category : 'accessing' }
StFileDialogPresenter >> fileReferenceTable [
	^ self fileNavigationSystem fileReferenceTable
]

{ #category : 'accessing' }
StFileDialogPresenter >> filter [

	^ filter ifNil: [ filter := StAllFilter new ]
]

{ #category : 'accessing' }
StFileDialogPresenter >> filter: aStFBFilter [

	filter := aStFBFilter.
	self fileNavigationSystem ifNotNil: [ self fileNavigationSystem filter: filter ]
]

{ #category : 'utilities' }
StFileDialogPresenter >> iconFor: anEntry [

	| ext |
	anEntry isDirectory ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		  at: ext
		  ifPresent: [ :icon | icon ]
		  ifAbsent: [ self iconNamed: #page ]
]

{ #category : 'initialization' }
StFileDialogPresenter >> initialize [

	super initialize.
	okAction := OkAction.
]

{ #category : 'initialization' }
StFileDialogPresenter >> initializeConfirmButton: aButton [

	| buttonEnableBlock |
	self allowsChooseDirectoryIfNoFilename ifTrue: [ ^ self ].
	buttonEnableBlock := [ :newText | aButton enabled: newText trimBoth isNotEmpty ].
	self fileNavigationSystem nameText whenTextChangedDo: buttonEnableBlock.
	buttonEnableBlock value: self fileNavigationSystem nameText text
]

{ #category : 'initialization' }
StFileDialogPresenter >> initializeDialogWindow: aDialogWindowPresenter [

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

{ #category : 'accessing' }
StFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : 'api - customization' }
StFileDialogPresenter >> isolate [
	self bookmarks: self bookmarks copy.
	
]

{ #category : 'accessing - ui' }
StFileDialogPresenter >> nameText [
	"Answer a <String> with the text in the name presenter used to display the currently selected file/directory or a manually entered name"

	^ fileNavigationSystem nameText text

]

{ #category : 'accessing' }
StFileDialogPresenter >> nameText: aString [ 

	fileNavigationSystem nameText: aString
]

{ #category : 'api - customization' }
StFileDialogPresenter >> okAction: aOneArgBlock [
	okAction := aOneArgBlock
]

{ #category : 'opening' }
StFileDialogPresenter >> open [

	^ self openDialog
]

{ #category : 'showing' }
StFileDialogPresenter >> openModal [

	super openModal cancelled ifTrue: [ ^ nil ].
	^ self selectedEntries
]

{ #category : 'api - customization' }
StFileDialogPresenter >> previewer: aPreviewer [ 
	self fileNavigationSystem previewer: aPreviewer
]

{ #category : 'utilities' }
StFileDialogPresenter >> selectFile: aFile [

	self fileNavigationSystem selectedEntry = aFile ifFalse: [ 
		self fileNavigationSystem fileReferenceTable selectItem: aFile ].
	self fileNavigationSystem nameText text: aFile basename
]

{ #category : 'accessing' }
StFileDialogPresenter >> selectedEntry [

	| entry |
	entry := self fileNavigationSystem selectedEntry.
	(self allowsChooseDirectoryIfNoFilename not and: [ 
		 entry exists and: [ entry isDirectory ] ]) ifTrue: [ 
		self inform: 'Only files could be selected (no directories)'.
		^ nil ].
	^ entry
]

{ #category : 'accessing' }
StFileDialogPresenter >> showDirectory: aFileReference [
	"Set the directory to be displayed to aFileReference"

	self fileNavigationSystem currentDirectory: aFileReference
]

{ #category : 'accessing - history' }
StFileDialogPresenter >> showFolder: aFolder [

	self currentDirectory: aFolder.
	aFolder exists ifTrue: [ self fileNavigationSystem showFolder: aFolder ]
]

{ #category : 'accessing' }
StFileDialogPresenter >> title [

	^ title
		ifNil: [ title := self windowTitle ]
]
