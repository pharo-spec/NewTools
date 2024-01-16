"
I'm a previewer for JPG , jpeg file 
	I provide a SpImagePresenter to show the picture
"
Class {
	#name : 'StFileBrowserJPGPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserJPGPreviewer >> matchingMimeType: aZnMimeType [

	^ aZnMimeType matches: ZnMimeType imageJpeg
]

{ #category : 'utilities' }
StFileBrowserJPGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | JPEGReadWriter formFromStream: stream ]);
		yourself
]
