"
I'm a previewer for PNG file 
	I provide a SpImagePresenter to show the picture
"
Class {
	#name : 'StFileBrowserPNGPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserPNGPreviewer >> matchingMimeType: element [

	^ element matches: ZnMimeType imagePng
]

{ #category : 'template method' }
StFileBrowserPNGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		autoScale: true;
		image: (aFileReference binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
