"
I am the abstract root of the open dialogs, `StOpenFilePresenter` and `StOpenDirectoryPresenter`. `StFileDialogPresenter` describes the dialogs and their customization.

## Responsibility:

- Show an 'Open' confirm button.
- Allow the user to select several entries (`beMultipleSelection`, `selectFiles:`).
- Answer the selected entries, or the current folder when nothing is selected and folders can be chosen.

## Collaborators:

- `StFileNavigationSystemPresenter`: holds the selection.

## Public API and Key Messages

- `beMultipleSelection`, `selectFiles: aCollection`, `selectedEntries`.

## Examples

```smalltalk
StOpenFilePresenter example.
StOpenDirectoryPresenter example.
```
"
Class {
	#name : 'StOpenFileOrDirectoryPresenter',
	#superclass : 'StFileDialogPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'hooks' }
StOpenFileOrDirectoryPresenter >> allowsChooseDirectoryIfNoFilename [

	^ true
]

{ #category : 'api' }
StOpenFileOrDirectoryPresenter >> beMultipleSelection [
	"Allow the user to select multiple files or directories in open dialogs"

	self fileNavigationSystem beMultipleSelection
]

{ #category : 'accessing - ui' }
StOpenFileOrDirectoryPresenter >> confirmLabel [

	^ 'Open'
]

{ #category : 'utilities' }
StOpenFileOrDirectoryPresenter >> selectFiles: aCollectionOfFiles [
	"Be ware that updating the name text from the file navigation system, would unselect all files"

	self beMultipleSelection.
	self fileNavigationSystem selectedEntries = aCollectionOfFiles
		ifFalse: [ self fileNavigationSystem selectEntries: aCollectionOfFiles ]
]

{ #category : 'menu - accessing' }
StOpenFileOrDirectoryPresenter >> selectedEntries [
	"Answer a <Collection> of user's selected <FileReference>s.
	
	When the user do not select any file reference and we allow to select a folder, return the current folder as in any other file browser."

	^ self fileNavigationSystem selectedEntries ifEmpty: [
			  self allowsChooseDirectoryIfNoFilename
				  ifTrue: [ { self fileNavigationSystem currentDirectory } ]
				  ifFalse: [ {  } ] ]
]
