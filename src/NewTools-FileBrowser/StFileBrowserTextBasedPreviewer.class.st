"
I'm a previewer use to display the text content of a file 
"
Class {
	#name : 'StFileBrowserTextBasedPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserTextBasedPreviewer >> canBeUsedOn: aFileReferenceOrString [
	"Answer <true> if aFileReferenceOrString is a non-empty text file"
	| fileRef |
	
	fileRef := aFileReferenceOrString asFileReference.
	^ fileRef isFile and: [ fileRef size ~= 0 and: [ self isTextStream: fileRef ] ]
]

{ #category : 'testing' }
StFileBrowserTextBasedPreviewer >> isTextStream: aZnCharacterReadStream [ 
	"Answer <true> if parameter represents a text stream"
	
	aZnCharacterReadStream readStreamDo: [ :s | 
		[ s next: self numberOfBytesToCheckForBinaryOrText ]
		   on: ZnInvalidUTF8
		   do: [ ^ false ] ].
	^ true
]

{ #category : 'testing' }
StFileBrowserTextBasedPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'private' }
StFileBrowserTextBasedPreviewer >> numberOfBytesToCheckForBinaryOrText [
	
	^ 100
]

{ #category : 'private' }
StFileBrowserTextBasedPreviewer >> numberOfBytesToDisplayInTextFile [

	^ 1000
]

{ #category : 'templateMethod' }
StFileBrowserTextBasedPreviewer >> previewActionOn: aFileReference [

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
