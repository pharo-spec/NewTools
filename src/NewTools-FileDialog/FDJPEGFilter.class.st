"
I am a filter selecting files with a jpeg extension.
"
Class {
	#name : #FDJPEGFilter,
	#superclass : #FDExtensionsFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDJPEGFilter >> basename [
	^ 'JPEG'
]

{ #category : #accessing }
FDJPEGFilter >> extensions [
	^ #('.jpg' '.jpeg' '.jpe' '.jfif')
]
