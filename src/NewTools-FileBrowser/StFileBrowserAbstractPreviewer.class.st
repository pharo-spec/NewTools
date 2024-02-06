"
I'm an abstract class to define a interface for a preview system 

my subclasses have to define :

* matchingMimeType: aZnMimeType
	return a Boolean to indicate if element matches

* previewOn: aFileReference 
	return a Presenter (son of SpPresenter)  
"
Class {
	#name : 'StFileBrowserAbstractPreviewer',
	#superclass : 'Object',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'accessing' }
StFileBrowserAbstractPreviewer class >> concreteViewerClasses [
	"Answer a <Collection> of receiver's subclasses which can actually read a <Stream> from a given file"
	
	^ StFileBrowserAbstractPreviewer subclasses difference: { 
			StFileBrowserInspectPreviewer . 
			StFileBrowserNullPreviewer .
			StFileBrowserAdaptiveContentPreviewer }
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer class >> isAbstract [
	^ self = StFileBrowserAbstractPreviewer
]

{ #category : 'accessing' }
StFileBrowserAbstractPreviewer class >> previewerFor: anExtensionString [
	"Answer a receiver's subclass matching anExtensionString or a null previewer <Class> if not found"
	
	^ self concreteViewerClasses
			detect: [ : class | class new canBeUsedOn: anExtensionString ]
			ifNone: [ StFileBrowserNullPreviewer new ]
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer >> canBeUsedOn: aFileReferenceOrString [

	aFileReferenceOrString ifNil: [ ^ false ].
	aFileReferenceOrString asFileReference mimeTypes ifNil: [ ^ false ] ifNotNil: [ :items | 
		^ items anySatisfy: [ :aZnMimeType | 
			  self matchingMimeType: aZnMimeType ] ]
]

{ #category : 'templateMethod' }
StFileBrowserAbstractPreviewer >> concreteViewerClasses [
	"See class side comment"

	^ self class concreteViewerClasses
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ self subclassResponsibility 
]

{ #category : 'templateMethod' }
StFileBrowserAbstractPreviewer >> previewActionOn: aFileReference [
	^ self subclassResponsibility
]

{ #category : 'utilities' }
StFileBrowserAbstractPreviewer >> previewOn: aFileReference [
	"Answer a <SpPresenter> suitable to preview the contents of aFileReference"
	
	(self canBeUsedOn: aFileReference)
		ifTrue: [ ^ self previewActionOn: aFileReference ].
	^ SpNullPresenter new
]
