"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : #FDOpenFileDialog,
	#superclass : #FDFileDialogPresenter,
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #api }
FDOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
FDOpenFileDialog >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable
]

{ #category : #accessing }
FDOpenFileDialog >> selectedEntry [
	^ fileNavigationSystem selectedEntry
]
