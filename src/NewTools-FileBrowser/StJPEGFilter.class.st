"
I am a filter selecting files with a jpeg extension.
"
Class {
	#name : 'StJPEGFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StJPEGFilter >> basename [
	^ 'JPEG'
]

{ #category : 'accessing' }
StJPEGFilter >> extensions [
	^ #('jpg' 'jpeg' 'jpe' 'jfif')
]
