"
I'm an abstract class to define a interface for a preview system 

my subclasses have to define :

* matchingMimeType: aZnMimeType
	return a Boolean to indicate if element matches

* previewOn: aFileReference 
	return a Presenter (son of SpPresenter)  
"
Class {
	#name : #StFBAbstractPreviewer,
	#superclass : #Object,
	#category : #'NewTools-FileBrowser-Previewers'
}

{ #category : #testing }
StFBAbstractPreviewer class >> isAbstract [
	^ self = StFBAbstractPreviewer
]

{ #category : #testing }
StFBAbstractPreviewer >> canBeUsedOn: aFileReference [

	aFileReference ifNil: [ ^ false ].
	aFileReference mimeTypes ifNil: [ ^ false ] ifNotNil: [ :items | 
		^ items anySatisfy: [ :aZnMimeType | 
			  self matchingMimeType: aZnMimeType ] ]
]

{ #category : #testing }
StFBAbstractPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ self subclassResponsibility 
]

{ #category : #templateMethod }
StFBAbstractPreviewer >> previewActionOn: aFileReference [
	^ self subclassResponsibility
]

{ #category : #utils }
StFBAbstractPreviewer >> previewOn: aFileReference [
	(self canBeUsedOn: aFileReference)
		ifTrue: [ ^ self previewActionOn: aFileReference ].
	^ SpNullPresenter new
]
