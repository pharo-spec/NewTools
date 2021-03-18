"
I'm a previewer use to display the content of a file 
"
Class {
	#name : #StFBContentPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : #templateMethod }
StFBContentPreviewer >> previewActionOn: aFileReference [
	^ SpTextPresenter new text: aFileReference contents 
]
