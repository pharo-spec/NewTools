"
I am a null previewer, I do not show anything
"
Class {
	#name : 'StFileBrowserNullPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserNullPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : 'testing' }
StFileBrowserNullPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'utilities' }
StFileBrowserNullPreviewer >> previewActionOn: aFileReference [

	^ SpNullPresenter new
]
