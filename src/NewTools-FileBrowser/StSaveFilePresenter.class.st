"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : 'StSaveFilePresenter',
	#superclass : 'StFileDialogPresenter',
	#instVars : [
		'confirmedOverwrite'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StSaveFilePresenter class >> defaultPreferredExtent [ 

	^ (1050 @ 550)
	
]

{ #category : 'examples' }
StSaveFilePresenter class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StSaveFilePresenter class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StSaveFilePresenter class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'accessing - ui' }
StSaveFilePresenter >> confirmLabel [

	^ 'Save'
]

{ #category : 'initialization' }
StSaveFilePresenter >> connectPresenters [

	| ec |
	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | 
			self fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ]
]

{ #category : 'accessing' }
StSaveFilePresenter >> existingFileMessage: entry [

	^ 'File named "{1}" already exists. Do you want to overwrite it?' format: { entry basename }
]

{ #category : 'hooks' }
StSaveFilePresenter >> initialTitle [
	^ 'Save As'
]

{ #category : 'initialization' }
StSaveFilePresenter >> initializePresenters [ 

	super initializePresenters.
	fileNavigationSystem layout: self rightPaneLayout
]

{ #category : 'showing' }
StSaveFilePresenter >> openModal [

	^ self asModalWindow open
]

{ #category : 'layout' }
StSaveFilePresenter >> rightPaneLayout [

	^ SpBoxLayout newTopToBottom
		add: fileNavigationSystem navigationLayout expand: false;
		add: fileNavigationSystem topPaneLayout;
		yourself
]

{ #category : 'accessing' }
StSaveFilePresenter >> selectedEntry [

	| entry |
	"This dialog returns a file reference to the current selected directory with the selected name text"
	entry := self currentDirectory / self nameText.

	"Add the extension if not already there"
	(self filter predicate: entry)
		ifFalse: [ entry := self filter addExtensionTo: entry ].

	entry exists ifFalse: [ ^ entry ].
	entry = confirmedOverwrite ifTrue: [ ^ entry ].
	(self application confirm: (self existingFileMessage: entry))
		ifTrue: [ ^ confirmedOverwrite := entry ].
	^ nil
]

{ #category : 'hooks' }
StSaveFilePresenter >> windowTitle [

	^ title ifNil: ['Save As']
]
