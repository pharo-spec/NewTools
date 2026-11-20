"
I am the dialog to choose a folder, titled 'Select Directory To Open'. `StFileDialogPresenter` describes the dialogs and their customization.

## Responsibility:

- List only folders, through my navigation presenter, a `StDirectoryNavigationSystemPresenter` (`navigationSystemClass`).
- Accept only a folder as choice, the current one when none is selected.

## Collaborators:

- `StDirectoryNavigationSystemPresenter`: my navigation presenter.
- `SpMorphicBackend>>newFileDialogFor:`: opens me for Spec folder dialogs.

## Public API and Key Messages

- `selectedEntry`: the chosen folder, or nil.

## Examples

```smalltalk
StOpenDirectoryPresenter example.
StOpenDirectoryPresenter exampleModal.
```
"
Class {
	#name : 'StOpenDirectoryPresenter',
	#superclass : 'StOpenFileOrDirectoryPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StOpenDirectoryPresenter class >> defaultPreferredExtent [ 

	^ (1050 @ 550)
]

{ #category : 'examples' }
StOpenDirectoryPresenter class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenDirectoryPresenter class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'hooks' }
StOpenDirectoryPresenter class >> navigationSystemClass [
	
	^ StDirectoryNavigationSystemPresenter 
]

{ #category : 'accessing' }
StOpenDirectoryPresenter >> selectedEntry [

	super selectedEntry ifNotNil: [ :fileReference | 
		fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'You must select a directory'.
	^ nil
]

{ #category : 'hooks' }
StOpenDirectoryPresenter >> windowTitle [

	^ title ifNil: [ 'Select Directory To Open' ]
]
