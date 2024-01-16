"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : 'StSaveFileDialog',
	#superclass : 'StFileDialogPresenter',
	#classTraits : '{} + TraitedClass',
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
			fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ]
]

{ #category : 'accessing - ui' }
StSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : 'accessing' }
StSaveFileDialog >> selectedEntry [

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
