"
I'm a previewer for PNG file 
	I provide a SpImagePresenter to show the picture
"
Class {
	#name : 'StFBPNGPreviewer',
	#superclass : 'StFBAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFBPNGPreviewer >> matchingMimeType: element [

	^ element matches: ZnMimeType imagePng
]

{ #category : 'utils' }
StFBPNGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
