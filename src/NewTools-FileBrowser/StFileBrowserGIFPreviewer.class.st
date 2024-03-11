"
I'm a previewer for GIF file 
	I provide a SpImagePresenter to show the picture
"
Class {
	#name : 'StFileBrowserGIFPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'testing' }
StFileBrowserGIFPreviewer >> matchingMimeType: element [

	^ element matches: ZnMimeType imageGif
]

{ #category : 'templateMethod' }
StFileBrowserGIFPreviewer >> previewActionOn: aFileReference [

	^ SpImagePresenter new
		autoScale: true;	
		image: (aFileReference binaryReadStreamDo: [ :stream | GIFReadWriter formFromStream: stream ]);
		yourself
]
