"
I am a filter selecting files with a bitmap extension.
"
Class {
	#name : #StFBBitmapFilter,
	#superclass : #StFBExtensionsFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBBitmapFilter >> basename [
	^ 'Bitmap'
]

{ #category : #accessing }
StFBBitmapFilter >> extensions [
	^ #('bmp' 'dib')
]
