"
I'm a previewer for JPG , jpeg file 
	I provide a SpImagePresenter to show the picture
"
Class {
	#name : #StFBJPGPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBJPGPreviewer >> matchingMimeType: aZnMimeType [

	^ aZnMimeType matches: ZnMimeType imageJpeg
]

{ #category : #utils }
StFBJPGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | JPEGReadWriter formFromStream: stream ]);
		yourself
]
