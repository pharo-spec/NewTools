"
I am a filter selecting files with a bitmap extension.
"
Class {
	#name : 'StFBBitmapFilter',
	#superclass : 'StFBExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBBitmapFilter >> basename [
	^ 'Bitmap'
]

{ #category : 'accessing' }
StFBBitmapFilter >> extensions [
	^ #('bmp' 'dib')
]
