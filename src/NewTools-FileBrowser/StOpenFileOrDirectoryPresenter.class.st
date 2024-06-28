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

{ #category : 'hooks' }
StOpenFileOrDirectoryPresenter >> initialTitle [
	^ self subclassResponsibility
]
