"
I am a filter selecting files with a gif extension.
"
Class {
	#name : 'StFBGIFFilter',
	#superclass : 'StFBExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBGIFFilter >> basename [
	^ 'GIF'
]

{ #category : 'accessing' }
StFBGIFFilter >> extensions [
	^ #('gif')
]
