"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : 'StSaveFileDialog',
	#superclass : 'StFileDialogPresenter',
	#instVars : [
		'confirmedOverwrite'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StSaveFileDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StSaveFileDialog class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StSaveFileDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'accessing - ui' }
StSaveFileDialog >> confirmLabel [

	^ 'Save'
]

{ #category : 'initialization' }
StSaveFileDialog >> connectPresenters [

	| ec |
	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | 
			self fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ]
]

{ #category : 'accessing' }
StSaveFileDialog >> existingFileMessage: entry [

	^ 'File named "{1}" already exists. Do you want to overwrite it?' format: { entry basename }
]

{ #category : 'initialization' }
StSaveFileDialog >> initialExtentForWindow [ 

	^ (1050 @ 550) scaledByDisplayScaleFactor
]

{ #category : 'hooks' }
StSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : 'initialization' }
StSaveFileDialog >> initializePresenters [ 

	super initializePresenters.
	fileNavigationSystem layout: self rightPaneLayout
]

{ #category : 'layout' }
StSaveFileDialog >> rightPaneLayout [

	^ SpBoxLayout newTopToBottom
		add: fileNavigationSystem navigationLayout expand: false;
		add: fileNavigationSystem topPaneLayout;
		yourself
]

{ #category : 'accessing' }
StSaveFileDialog >> selectedEntry [

	| entry |
	entry := super selectedEntry ifNil: [ ^ nil ].
	entry := filter addExtensionTo: entry.
	entry exists ifFalse: [ ^ entry ].
	entry = confirmedOverwrite ifTrue: [ ^ entry ].
	(self application confirm: (self existingFileMessage: entry))
		ifTrue: [ ^ confirmedOverwrite := entry ].
	^ nil
]
