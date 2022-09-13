"
I'm a previewer use to display the text content of a file 
"
Class {
	#name : #StFBContentPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBContentPreviewer >> canBeUsedOn: aFileReference [
	^ aFileReference isFile
]

{ #category : #testing }
StFBContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : #templateMethod }
StFBContentPreviewer >> previewActionOn: aFileReference [

	^ SpTextPresenter new text: ([ 
		   aFileReference readStreamDo: [ :s | 
			   | text |
			   text := s next: 500000.
			   s atEnd
				   ifTrue: [ text ]
				   ifFalse: [ 
				   text , (String cr , String cr , ' ... truncated ... ') ] ] ]
			   on: ZnInvalidUTF8
			   do: [ 'No preview' ])
]
