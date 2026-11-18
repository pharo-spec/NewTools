"
I am the dialog to choose where to save a file, titled 'Save As', with a 'Save' button. `StFileDialogPresenter` describes the dialogs and their customization; here is what is specific to me.

## Responsibility:

- Answer the file named by the name field in the current folder, even when it does not exist yet.
- Add the extension of the filter when the name does not have it (`StExtensionsFilter>>addExtensionTo:`).
- Ask the user to confirm before answering an existing file.

## Collaborators:

- Code saving a file, e.g. `EpChunkExporter`, `Fileouter`.
- `StFileBrowserAbstractFilter`: completes the name.

## Public API and Key Messages

- `okAction: aOneArgBlock`: evaluated with the chosen file; my `openModal` answers my window, not the file.
- `extensions: aCollection`, `nameText: aString`, `selectedEntry`.

## Examples

```smalltalk
StSaveFilePresenter example.
StSaveFilePresenter exampleExtensions.
StSaveFilePresenter exampleModal.
```

## Internal Representation

- `confirmedOverwrite`: the existing file the user agreed to overwrite, so that the question is not asked twice.
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
