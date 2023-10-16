"
Main UI window for the file browser.

Originally based on 

Pharo-Harbour https://github.com/astares/Pharo-Harbour
A simple file browser experiment for Pharo written by T. Bergmann (Astares) in 2019.

Clases got renamed to avoid name clashes. 
"
Class {
	#name : 'StSimpleFileBrowserPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'menu',
		'statusBar',
		'toolBar',
		'pathNamePresenter',
		'folderContentPresenter',
		'folderStructurePresenter'
	],
	#category : 'NewTools-SimpleFileBrowser-UI-Windows',
	#package : 'NewTools-SimpleFileBrowser-UI',
	#tag : 'Windows'
}

{ #category : 'specs' }
StSimpleFileBrowserPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom 		 
		 add: #pathNamePresenter expand: false;
		 add: (SpPanedLayout newLeftToRight
				position: 30 percent;
				add: #folderStructurePresenter;
				add: #folderContentPresenter;
				yourself);
		yourself		
]

{ #category : 'accessing' }
StSimpleFileBrowserPresenter class >> icon [ 
	^StSimpleIconCache driveIcon
]

{ #category : 'world menu' }
StSimpleFileBrowserPresenter class >> menuCommandOn: aBuilder [ 
	<worldMenu> 
	(aBuilder item: #'File Manager')
		parent: #'Tools';
		help: 'File Manager';
		action: [ self open ]; 
		order: 3.0; 
		icon: self icon. 
	
]

{ #category : 'showing' }
StSimpleFileBrowserPresenter class >> open [
	<script>

	self new openWithSpec
]

{ #category : 'accessing' }
StSimpleFileBrowserPresenter class >> systemIcon [ 
	^self icon
]

{ #category : 'accessing' }
StSimpleFileBrowserPresenter class >> taskbarIcon [ 
	^self icon
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildExtrasMenu [

	^ self newMenu
		addItem: [ :item | item name: 'Open Terminal'; action: [ self openTerminal ] ];	 
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildFileMenu [

	^ self newMenu
		addItem: [ :item | item name: 'Browse'; action: [ self openNativeFileBrowser ] ];	 
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildMenuBar [
	^ self newMenuBar
		addGroup: [ :group | 
			group addItem: [ :item | 
					item
						name: 'File';
						subMenu: self buildFileMenu ].
			group addItem: [ :item | 
					item
						name: 'Extras';
						subMenu: self buildExtrasMenu ] ]
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildNavigateBackToolBarItem [
		
	^ SpToolbarButtonPresenter new
		label: 'Back';
		icon: (self iconNamed: #back);
		help: 'Navigate to previous';
		action: [ self pushMessage ];
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildNavigateForwardToolBarItem [
		
	^ SpToolbarButtonPresenter new
		label: 'Forward';
		icon: (self iconNamed: #forward);
		help: 'Navigate to previous item';
		action: [ self pushMessage ];
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildOpenNativeFileBrowserToolBarItem [
		
	^ SpToolbarButtonPresenter new
		label: 'Browse';
		icon: StSimpleIconCache folderIcon;
		help: 'Open file browser';
		action: [ self openNativeFileBrowser ];
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildOpenTerminalToolBarItem [
		
	^ SpToolbarButtonPresenter new
		label: 'Terminal';
		icon: StSimpleIconCache terminalIcon;
		help: 'Open terminal';
		action: [ self openTerminal ];
		yourself
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildStatusBar [

	^ SpStatusBarPresenter new
]

{ #category : 'private - building' }
StSimpleFileBrowserPresenter >> buildToolBar [
	
	^ self newToolbar 
		addItem: self buildNavigateBackToolBarItem;
		addItem: self buildNavigateForwardToolBarItem;		
		addItem: self buildOpenNativeFileBrowserToolBarItem;			
		addItem: self buildOpenTerminalToolBarItem "position: ToolBarItemPosition right";				
		yourself
]

{ #category : 'defaults' }
StSimpleFileBrowserPresenter >> initialExtent [ 
	^ 700 @ 500
]

{ #category : 'initialization' }
StSimpleFileBrowserPresenter >> initializePresenters [

	pathNamePresenter := self instantiate: StSimplePathNamePresenter.
	folderStructurePresenter := self instantiate: StSimpleFolderStructurePresenter.
	folderContentPresenter := self instantiate: StSimpleFolderContentPresenter.
	
	folderStructurePresenter whenFolderChangedDo: [ :folder | 
		pathNamePresenter pathName: folder pathString.
		folderContentPresenter folder: folder ].

	folderContentPresenter whenItemsChangedDo: [ :items |
		self statusBar pushMessage: (self statusTextFor: items) ]
]

{ #category : 'initialization' }
StSimpleFileBrowserPresenter >> initializeWindow: aWindowPresenter [
	"I'm called whenever the component will be displayed in a window (or dialog). 
	 This is usually attained sending #openWithSpec or #openDialogWithSpec."
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		"menu: (menu := self buildMenuBar);"
		toolbar: (toolBar := self buildToolBar);
		statusBar: (statusBar := self buildStatusBar);
		whenOpenedDo: [ self selectLastPath ].

	self statusBar pushMessage: 'Ready'	
]

{ #category : 'private - accessing' }
StSimpleFileBrowserPresenter >> lastPath [

	^ FileLocator home
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> menu [
	^ menu
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> menu: anObject [
	^ menu := anObject
]

{ #category : 'showing' }
StSimpleFileBrowserPresenter >> open [ 
	<script: 'self open'>
	self class open
]

{ #category : 'actions' }
StSimpleFileBrowserPresenter >> openNativeFileBrowser [

	pathNamePresenter openNativeFileBrowser
]

{ #category : 'actions' }
StSimpleFileBrowserPresenter >> openTerminal [

	StSimpleFileUtils openTerminalOn: pathNamePresenter pathName
	
]

{ #category : 'actions' }
StSimpleFileBrowserPresenter >> pushMessage [
	
	statusBar pushMessage: 'HelloWorld'
]

{ #category : 'private - accessing' }
StSimpleFileBrowserPresenter >> selectLastPath [

	self selectPath: self lastPath fullPath withParents
]

{ #category : 'private - accessing' }
StSimpleFileBrowserPresenter >> selectPath: path [

	folderStructurePresenter selectPathByItems: path
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> statusBar [
	^ statusBar
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> statusBar: anObject [
	^ statusBar := anObject
]

{ #category : 'private - accessing' }
StSimpleFileBrowserPresenter >> statusTextFor: aCollection [ 
	 
	| onlyFiles text |
	onlyFiles := aCollection allSatisfy: [:each | each isFile].
	text := String streamContents: [:s | 
		s nextPutAll: aCollection size asString.
		s nextPutAll: ' element'.
      aCollection size > 1 ifTrue: [ s nextPut: $s ].	"handle plural"
		s nextPutAll: ' selected'		
	].
	^text
]

{ #category : 'defaults' }
StSimpleFileBrowserPresenter >> title [ 

   ^'File browser'
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> toolBar [
	^ toolBar
]

{ #category : 'accessing - ui' }
StSimpleFileBrowserPresenter >> toolBar: anObject [
	^ toolBar := anObject
]

{ #category : 'initialization' }
StSimpleFileBrowserPresenter >> updatePresenter [

]
