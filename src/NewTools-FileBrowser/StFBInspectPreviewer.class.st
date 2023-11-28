"
I'm a inspector previewer 
"
Class {
	#name : 'StFBInspectPreviewer',
	#superclass : 'StFBAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFBInspectPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : 'testing' }
StFBInspectPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'templateMethod' }
StFBInspectPreviewer >> previewActionOn: aFileReference [
	^ StObjectInspectorPresenter onObject: aFileReference
]
