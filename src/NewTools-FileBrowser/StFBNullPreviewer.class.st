"
I'm a null patern , the default previewer
"
Class {
	#name : #StFBNullPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBNullPreviewer >> canBeUsedOn: aFileReference [
	^ aFileReference isFile
]

{ #category : #testing }
StFBNullPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : #utils }
StFBNullPreviewer >> previewActionOn: aFileReference [
	^ SpTextPresenter new text: aFileReference contents

]
