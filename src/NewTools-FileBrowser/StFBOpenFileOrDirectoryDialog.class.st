Class {
	#name : #StFBOpenFileOrDirectoryDialog,
	#superclass : #StFBFileDialogPresenter,
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #'accessing - ui' }
StFBOpenFileOrDirectoryDialog >> confirmLabel [

	^ 'Open'
]

{ #category : #hooks }
StFBOpenFileOrDirectoryDialog >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
StFBOpenFileOrDirectoryDialog >> initializePresenters [

	super initializePresenters.
	fileNavigationSystem nameText disable
]
