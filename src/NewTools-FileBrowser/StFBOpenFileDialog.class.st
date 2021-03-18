"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : #StFBOpenFileDialog,
	#superclass : #StFBFileDialogPresenter,
	#instVars : [
		'nameText',
		'confirmButton'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #api }
StFBOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
StFBOpenFileDialog >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable.
	nameText disable.
	confirmButton label: 'Open'	
]

{ #category : #accessing }
StFBOpenFileDialog >> selectedEntry [
	^ fileNavigationSystem selectedEntry
]
