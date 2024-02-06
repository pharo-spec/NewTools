"
This is a surrogate previewer which tries all possible alternatives to preview a file.

"
Class {
	#name : 'StFileBrowserAdaptiveContentPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

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
		ifNone: [ StFileBrowserTextBasedContentPreviewer new previewActionOn: aFileReference ].

]
