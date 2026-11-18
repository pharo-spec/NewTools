"
I preview JPEG images. `StFileBrowserAbstractPreviewer` describes how previewers are created and used.

## Responsibility:

- Accept the files whose MIME type, found from their extension, is `image/jpeg` (`matchingMimeType:`).
- Read the picture with `JPEGReadWriter` and show it, scaled to the pane, in a `SpImagePresenter`.

## Collaborators:

- `StFileBrowserAdaptiveContentPreviewer`: chooses me for these files.
- `JPEGReadWriter`, `SpImagePresenter`: read and show the picture.

## Public API and Key Messages

- `previewOn: aFileReference`: inherited.

## Examples

```smalltalk
StFileBrowserJPGPreviewer exampleJPG.
```
"
Class {
	#name : 'StFileBrowserJPGPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserJPGPreviewer class >> exampleJPG [

	<sampleInstance>
	^ self new
]

{ #category : 'testing' }
StFileBrowserJPGPreviewer >> matchingMimeType: aZnMimeType [

	^ aZnMimeType matches: ZnMimeType imageJpeg
]

{ #category : 'utilities' }
StFileBrowserJPGPreviewer >> previewActionOn: aFileReference [
	^ SpImagePresenter new
		autoScale: true;
		image: (aFileReference binaryReadStreamDo: [ :stream | JPEGReadWriter formFromStream: stream ]);
		yourself
]
