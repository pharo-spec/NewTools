"
I am a filter selecting files with a gif extension.
"
Class {
	#name : 'StGIFFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StGIFFilter >> basename [
	^ 'GIF'
]

{ #category : 'accessing' }
StGIFFilter >> extensions [
	^ #('gif')
]
