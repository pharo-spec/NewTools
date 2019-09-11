"
I am a filter selecting files with a bitmap extension.
"
Class {
	#name : #FDBitmapFilter,
	#superclass : #FDExtensionsFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDBitmapFilter >> basename [
	^ 'Bitmap'
]

{ #category : #accessing }
FDBitmapFilter >> extensions [
	^ #('.bmp' '.dib')
]
