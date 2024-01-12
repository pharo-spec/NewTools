Class {
	#name : 'StFBOpenFileOrDirectoryDialog',
	#superclass : 'StFBFileDialogPresenter',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing - ui' }
StFBOpenFileOrDirectoryDialog >> confirmLabel [

	^ 'Open'
]

{ #category : 'hooks' }
StFBOpenFileOrDirectoryDialog >> initialTitle [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
StFBOpenFileOrDirectoryDialog >> initializePresenters [

	super initializePresenters.
	fileNavigationSystem nameText disable
]
