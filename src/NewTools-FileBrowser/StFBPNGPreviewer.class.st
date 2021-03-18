"
i'm creating 

a SpImagePresenter of PNG file
"
Class {
	#name : #StFBPNGPreviewer,
	#superclass : #StFBAbstractPreviewer,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBPNGPreviewer >> matchingMimeType: element [
	^ element matches:  ZnMimeType imagePng
]

{ #category : #utils }
StFBPNGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
