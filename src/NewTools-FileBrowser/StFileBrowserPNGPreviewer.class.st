"
I preview PNG images. `StFileBrowserAbstractPreviewer` describes how previewers are created and used.

## Responsibility:

- Accept the files whose MIME type, found from their extension, is `image/png` (`matchingMimeType:`).
- Read the picture with `PNGReadWriter` and show it, scaled to the pane, in a `SpImagePresenter`.

## Collaborators:

- `StFileBrowserAdaptiveContentPreviewer`: chooses me for these files.
- `PNGReadWriter`, `SpImagePresenter`: read and show the picture.

## Public API and Key Messages

- `previewOn: aFileReference`: inherited.

## Examples

```smalltalk
StFileBrowserPNGPreviewer examplePNG.
```
"
Class {
	#name : 'StFileBrowserPNGPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserPNGPreviewer class >> examplePNG [

	<sampleInstance>
	^ self new
]

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
