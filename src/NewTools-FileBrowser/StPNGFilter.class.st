"
I am a filter selecting files with a png extension.
"
Class {
	#name : 'StPNGFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StPNGFilter >> basename [
	^ 'PNG'
]

{ #category : 'accessing' }
StPNGFilter >> extensions [
	^ #('png')
]
