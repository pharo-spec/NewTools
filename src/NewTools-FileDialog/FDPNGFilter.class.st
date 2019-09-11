"
I am a filter selecting files with a png extension.
"
Class {
	#name : #FDPNGFilter,
	#superclass : #FDExtensionsFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDPNGFilter >> basename [
	^ 'PNG'
]

{ #category : #accessing }
FDPNGFilter >> extensions [
	^ #('.png')
]
