"
I am the default previewer of the file dialogs: I choose how to preview each file. `StFileBrowserAbstractPreviewer` describes how previewers are created and used.

## Responsibility:

- Preview any file (not a directory) with the first of `concreteViewerClasses` that can be used on it: the GIF, JPG or PNG previewer for an image, the text previewer for a text file.
- Fall back to the text previewer when none of them can be used.

## Collaborators:

- `StFileNavigationSystemPresenter>>defaultPreviewer`: creates me.
- `StFileBrowserGIFPreviewer`, `StFileBrowserJPGPreviewer`, `StFileBrowserPNGPreviewer`, `StFileBrowserTextBasedPreviewer`: do the preview.

## Public API and Key Messages

- `previewOn:`, inherited.

## Examples

```smalltalk
StFileBrowserAdaptiveContentPreviewer exampleAdaptive.
```
"
Class {
	#name : 'StFileBrowserAdaptiveContentPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserAdaptiveContentPreviewer class >> exampleAdaptive [

	<sampleInstance>
	^ self new
]

{ #category : 'testing' }
StFileBrowserAdaptiveContentPreviewer >> canBeUsedOn: aFileReferenceOrString [

	^ aFileReferenceOrString asFileReference isFile
]

{ #category : 'testing' }
StFileBrowserAdaptiveContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	
	^ true
]

{ #category : 'templateMethod' }
StFileBrowserAdaptiveContentPreviewer >> previewActionOn: aFileReference [
	"Answer a <SpPresenter> to preview the contents of aFileReference"

	^ self concreteViewerClasses
		detect: [ : viewerClass | viewerClass new canBeUsedOn: aFileReference ]
		ifFound: [ : foundPreviewerClass | foundPreviewerClass new previewActionOn: aFileReference ]
		ifNone: [ StFileBrowserTextBasedPreviewer new previewActionOn: aFileReference ].

]
