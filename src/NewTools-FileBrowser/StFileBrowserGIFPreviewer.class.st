"
I preview GIF images. `StFileBrowserAbstractPreviewer` describes how previewers are created and used.

## Responsibility:

- Accept the files whose MIME type, found from their extension, is `image/gif` (`matchingMimeType:`).
- Read the picture with `GIFReadWriter` and show it, scaled to the pane, in a `SpImagePresenter`.

## Collaborators:

- `StFileBrowserAdaptiveContentPreviewer`: chooses me for these files.
- `GIFReadWriter`, `SpImagePresenter`: read and show the picture.

## Public API and Key Messages

- `previewOn: aFileReference`: inherited.

## Examples

```smalltalk
StFileBrowserGIFPreviewer exampleGIF.
```
"
Class {
	#name : 'StFileBrowserGIFPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserGIFPreviewer class >> exampleGIF [

	<sampleInstance>
	^ self new
]

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
