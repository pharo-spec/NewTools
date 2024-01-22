"
This is an abstract class to group open dialog presenter behavior.
See subclasses for specific users.
"
Class {
	#name : 'StOpenFileOrDirectoryDialog',
	#superclass : 'StFileDialogPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing - ui' }
StOpenFileOrDirectoryDialog >> confirmLabel [

	^ 'Open'
]

{ #category : 'hooks' }
StOpenFileOrDirectoryDialog >> initialTitle [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
StOpenFileOrDirectoryDialog >> initializePresenters [

	super initializePresenters.
	fileNavigationSystem nameText disable
]
