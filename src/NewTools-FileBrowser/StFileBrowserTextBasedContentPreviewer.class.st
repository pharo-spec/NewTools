"
I'm a previewer use to display the text content of a file 
"
Class {
	#name : 'StFileBrowserTextBasedContentPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserTextBasedContentPreviewer >> canBeUsedOn: aFileReferenceOrString [
	"Answer <true> if aFileReferenceOrString is a non-empty text file"
	| fileRef |
	
	fileRef := aFileReferenceOrString asFileReference.
	^ fileRef isFile and: [ fileRef size ~= 0 and: [ self isTextStream: fileRef ] ]
]

{ #category : 'testing' }
StFileBrowserTextBasedContentPreviewer >> isTextStream: aZnCharacterReadStream [ 
	"Answer <true> if parameter represents a text stream"
	
	aZnCharacterReadStream readStreamDo: [ :s | 
		[ s next: self numberOfBytesToCheckForBinaryOrText ]
		   on: ZnInvalidUTF8
		   do: [ ^ false ] ].
	^ true
]

{ #category : 'testing' }
StFileBrowserTextBasedContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'private' }
StFileBrowserTextBasedContentPreviewer >> numberOfBytesToCheckForBinaryOrText [
	
	^ 100
]

{ #category : 'private' }
StFileBrowserTextBasedContentPreviewer >> numberOfBytesToDisplayInTextFile [

	^ 1000
]

{ #category : 'templateMethod' }
StFileBrowserTextBasedContentPreviewer >> previewActionOn: aFileReference [

	^ SpTextPresenter new text: ([ 
		   aFileReference readStreamDo: [ :s | 
			   | text |
			   text := s next: self numberOfBytesToDisplayInTextFile.
			   s atEnd
				   ifTrue: [ text ]
				   ifFalse: [ 
				   text , (String cr , String cr , ' ... truncated ... ') ] ] ]
			   on: ZnInvalidUTF8
			   do: [ 'No preview' ])
]
