"
I am a filter selecting files with a bitmap extension.
"
Class {
	#name : 'StBitmapFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StBitmapFilter >> basename [
	^ 'Bitmap'
]

{ #category : 'accessing' }
StBitmapFilter >> extensions [
	^ #('bmp' 'dib')
]
