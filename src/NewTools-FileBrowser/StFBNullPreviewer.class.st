"
I am a null previewer, I do not show anything
"
Class {
	#name : #StFBNullPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBNullPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : #testing }
StFBNullPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : #utils }
StFBNullPreviewer >> previewActionOn: aFileReference [

	^ SpNullPresenter new
]
