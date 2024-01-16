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

{ #category : 'testing' }
StFileBrowserAbstractPreviewer class >> isAbstract [
	^ self = StFileBrowserAbstractPreviewer
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer >> canBeUsedOn: aFileReference [

	aFileReference ifNil: [ ^ false ].
	aFileReference mimeTypes ifNil: [ ^ false ] ifNotNil: [ :items | 
		^ items anySatisfy: [ :aZnMimeType | 
			  self matchingMimeType: aZnMimeType ] ]
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
	(self canBeUsedOn: aFileReference)
		ifTrue: [ ^ self previewActionOn: aFileReference ].
	^ SpNullPresenter new
]
