"
I'm a previewer use to display the text content of a file 
"
Class {
	#name : 'StFileBrowserContentPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserContentPreviewer >> canBeUsedOn: aFileReference [
	^ aFileReference isFile
]

{ #category : 'testing' }
StFileBrowserContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'templateMethod' }
StFileBrowserContentPreviewer >> previewActionOn: aFileReference [

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
