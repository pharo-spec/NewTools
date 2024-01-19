"
I'm a inspector previewer 
"
Class {
	#name : 'StFileBrowserInspectPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserInspectPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : 'testing' }
StFileBrowserInspectPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'templateMethod' }
StFileBrowserInspectPreviewer >> previewActionOn: aFileReference [
	^ StObjectInspectorPresenter onObject: aFileReference
]
