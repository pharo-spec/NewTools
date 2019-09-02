"
I'm a inspector previewer 
"
Class {
	#name : #FDInspectPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'NewTools-FileDialog-Previewers'
}

{ #category : #testing }
FDInspectPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : #testing }
FDInspectPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : #templateMethod }
FDInspectPreviewer >> previewActionOn: aFileReference [
	^ StInspector instanciateOn: aFileReference
]
