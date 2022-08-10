"
I am a filter selecting files with a gif extension.
"
Class {
	#name : #StFBGIFFilter,
	#superclass : #StFBExtensionsFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBGIFFilter >> basename [
	^ 'GIF'
]

{ #category : #accessing }
StFBGIFFilter >> extensions [
	^ #('gif')
]
