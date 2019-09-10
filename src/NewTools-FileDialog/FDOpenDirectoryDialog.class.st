"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : #FDOpenDirectoryDialog,
	#superclass : #FDFileDialogPresenter,
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #examples }
FDOpenDirectoryDialog class >> example [
	<example>
	^ (self new
		okAction: [ :selectedFileReference | selectedFileReference inspect ])
		openDialogWithSpec inspect
]

{ #category : #api }
FDOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : #initialization }
FDOpenDirectoryDialog >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable
]

{ #category : #actions }
FDOpenDirectoryDialog >> nameChanged [
	"we don't need to do anything for folder"

	
]

{ #category : #actions }
FDOpenDirectoryDialog >> selectedEntry [
	fileNavigationSystem selectedEntry ifNotNil: [ :fileReference | fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'you must select a directory'
]
