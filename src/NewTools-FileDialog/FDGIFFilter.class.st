"
I am a filter selecting files with a gif extension.
"
Class {
	#name : #FDGIFFilter,
	#superclass : #FDExtensionsFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDGIFFilter >> basename [
	^ 'GIF'
]

{ #category : #accessing }
FDGIFFilter >> extensions [
	^ #('.gif')
]
