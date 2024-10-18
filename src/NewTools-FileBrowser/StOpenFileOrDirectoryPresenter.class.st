"
This is an abstract class to group open dialog presenter behavior.
See subclasses for specific users.
"
Class {
	#name : 'StOpenFileOrDirectoryPresenter',
	#superclass : 'StFileDialogPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

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
	"Answer a <Collection> of user's selected <FileReference>s "

	| entries |
	((entries := self fileNavigationSystem selectedEntries) 
		anySatisfy: [ : entry | (entry exists not and: [ entry isDirectory ]) ])
			ifTrue: [ 
				self inform: 'Only files could be selected (no directories)'.
				^ nil ].
	^ entries
]
