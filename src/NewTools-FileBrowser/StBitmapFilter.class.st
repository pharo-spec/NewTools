"
I am the extension filter of bitmap images, shown as 'Bitmap (*.bmp,*.dib)'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used, and `StExtensionsFilter` how extension filters work.

## Responsibility:

- Give the extensions of bitmap images and the basename of my name.

## Collaborators:

- `StExtensionsFilter`: my superclass does the filtering, the name and the name completion.

## Public API and Key Messages

- `extensions`, `basename`.

## Examples

```smalltalk
StBitmapFilter exampleBitmap.
```
"
Class {
	#name : 'StBitmapFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StBitmapFilter class >> exampleBitmap [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StBitmapFilter >> basename [
	^ 'Bitmap'
]

{ #category : 'accessing' }
StBitmapFilter >> extensions [
	^ #('bmp' 'dib')
]
