"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : #StFBOpenDirectoryDialog,
	#superclass : #StFBFileDialogPresenter,
	#instVars : [
		'nameText',
		'confirmButton'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #specs }
StFBOpenDirectoryDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | c add: #bookmarksList ] width: 150;
				newColumn: [ :c | 
					c add: #currentFolderLabel height: self toolbarHeight.
					c add: #filesList ] ];
		newRow: [ :r | 
			r newColumn: [ :c |  ].
			self dialogButtonsLayout: r ]
			height: self toolbarHeight;
		yourself
]

{ #category : #examples }
StFBOpenDirectoryDialog class >> example [
	<example>
	^ (self new
		okAction: [ :selectedFileReference | selectedFileReference inspect ])
		openDialogWithSpec inspect
]

{ #category : #accessing }
StFBOpenDirectoryDialog >> filesFilteringBlock [
	^ [ :entries | 
	| e |
	e := filter directoriesOnly: entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: e ].
	e ]
]

{ #category : #'accessing - ui' }
StFBOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : #initialization }
StFBOpenDirectoryDialog >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable.
	nameText disable.
	confirmButton
		label: 'Open';
		enable
]

{ #category : #actions }
StFBOpenDirectoryDialog >> nameChanged [
	"we don't need to do anything for folder"

	
]

{ #category : #actions }
StFBOpenDirectoryDialog >> selectedEntry [
	fileNavigationSystem selectedEntry ifNotNil: [ :fileReference | fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'you must select a directory'
]
