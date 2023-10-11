"
I am a filter selecting files with a jpeg extension.
"
Class {
	#name : 'StFBJPEGFilter',
	#superclass : 'StFBExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBJPEGFilter >> basename [
	^ 'JPEG'
]

{ #category : 'accessing' }
StFBJPEGFilter >> extensions [
	^ #('jpg' 'jpeg' 'jpe' 'jfif')
]
