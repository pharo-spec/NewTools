"
I am the dialog to choose a file to open, titled 'Select File To Open'. `StFileDialogPresenter` describes the dialogs and their customization.

## Responsibility:

- Accept only a file as choice, not a folder.
- Tell whether several files can be chosen (`isMultipleSelection`).

## Collaborators:

- Code asking the user for a file, e.g. `StLabeledSettingFileSelectionPresenter`, `IceTipFilePresenter`.

## Public API and Key Messages

- `extensions: aCollection named: aString` then `openModal`: answers the selected files, or nil when cancelled.
- `beMultipleSelection`, `isMultipleSelection`.

## Examples

```smalltalk
StOpenFilePresenter example.
StOpenFilePresenter exampleExtensions.
StOpenFilePresenter examplePreviewer.
StOpenFilePresenter exampleModal.
```

`example` inspects the chosen file, `exampleExtensions` lists only Pharo images, `examplePreviewer` previews with an inspector, and `exampleModal` waits for the choice.
"
Class {
	#name : 'StOpenFilePresenter',
	#superclass : 'StOpenFileOrDirectoryPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StOpenFilePresenter class >> complexExampleAdaptivePreviewer [

	<example>
	| presenter |
	presenter := self new.
	presenter filter: (StCustomExtensionsFilter extensions: #( '.image' )).
	"you can add 1 own filter"

	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"

	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "

	presenter bookmarks: { (StFileBrowserGroupBookmark
			 name: 'exampleGroup'
			 collection: { 
					 StFileBrowserBookmark image.
					 StFileBrowserBookmark home }
			 iconName: 'group') }.
	"you define the bookmarks have to be instance of FDAbstractBookMark"

	presenter columns: { StFileBrowserCreationDateColumn }.

	"presenter inspect."
	presenter openModal.
	presenter resetBookmarks.
	^ presenter confirm
]

{ #category : 'examples' }
StOpenFilePresenter class >> complexExampleTextPreviewer [

	<example>
	| presenter |
	presenter := self new.

	presenter previewer: StFileBrowserTextBasedPreviewer new.
	"with this when you select a png file it will display it"

	presenter filter: (StCustomExtensionsFilter extensions: #( '.image' )).
	"you can add 1 own filter"

	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"

	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "

	presenter bookmarks: { (StFileBrowserGroupBookmark
			 name: 'exampleGroup'
			 collection: { 
					 StFileBrowserBookmark image.
					 StFileBrowserBookmark home }
			 iconName: 'group') }.
	"you define the bookmarks have to be instance of FDAbstractBookMark"

	presenter columns: { StFileBrowserCreationDateColumn }.

	presenter inspect.
	presenter openModal.
	presenter resetBookmarks.
	^ presenter confirm
]

{ #category : 'examples' }
StOpenFilePresenter class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenFilePresenter class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StOpenFilePresenter class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'examples' }
StOpenFilePresenter class >> examplePreviewer [

	self new
		previewer: StFileBrowserInspectPreviewer new;
		open
]

{ #category : 'hooks' }
StOpenFilePresenter >> allowsChooseDirectoryIfNoFilename [

	^ false
]

{ #category : 'testing' }
StOpenFilePresenter >> isMultipleSelection [
	"Answer <true> if the receiver was set to enable multiple selections"
	
	^ self fileNavigationSystem isMultipleSelection 
]

{ #category : 'hooks' }
StOpenFilePresenter >> windowTitle [

	^ title ifNil: ['Select File To Open']
]
