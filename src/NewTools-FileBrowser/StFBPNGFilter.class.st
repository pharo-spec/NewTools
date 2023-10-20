"
I am a filter selecting files with a png extension.
"
Class {
	#name : 'StFBPNGFilter',
	#superclass : 'StFBExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBPNGFilter >> basename [
	^ 'PNG'
]

{ #category : 'accessing' }
StFBPNGFilter >> extensions [
	^ #('png')
]
