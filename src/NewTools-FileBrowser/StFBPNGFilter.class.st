"
I am a filter selecting files with a png extension.
"
Class {
	#name : #StFBPNGFilter,
	#superclass : #StFBExtensionsFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBPNGFilter >> basename [
	^ 'PNG'
]

{ #category : #accessing }
StFBPNGFilter >> extensions [
	^ #('png')
]
