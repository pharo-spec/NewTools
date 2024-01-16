"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : 'StFBSaveFileDialog',
	#superclass : 'StFBFileDialogPresenter',
	#instVars : [
		'confirmedOverwrite'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StFBSaveFileDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StFBSaveFileDialog class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StFBSaveFileDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'accessing - ui' }
StFBSaveFileDialog >> confirmLabel [

	^ 'Save'
]

{ #category : 'initialization' }
StFBSaveFileDialog >> connectPresenters [

	| ec |
	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | 
			fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ]
]

{ #category : 'accessing - ui' }
StFBSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : 'accessing' }
StFBSaveFileDialog >> selectedEntry [

	| entry |
	entry := super selectedEntry ifNil: [ ^ nil ].
	entry := filter addExtensionTo: entry.
	entry exists ifFalse: [ ^ entry ].
	entry = confirmedOverwrite ifTrue: [ ^ entry ].
	(UIManager default proceed:
		 ('File named "{1}" already exists. Do you want to overwrite it?' 
			  format: { entry basename })) ifTrue: [ 
		^ confirmedOverwrite := entry ].
	^ nil
]
