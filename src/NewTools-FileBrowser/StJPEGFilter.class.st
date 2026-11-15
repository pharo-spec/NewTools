"
I am the extension filter of JPEG images, shown as 'JPEG (*.jpg,*.jpeg,*.jpe,*.jfif)'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used, and `StExtensionsFilter` how extension filters work.

## Responsibility:

- Give the extensions of JPEG images and the basename of my name.

## Collaborators:

- `StExtensionsFilter`: my superclass does the filtering, the name and the name completion.

## Public API and Key Messages

- `extensions`, `basename`.

## Examples

```smalltalk
StJPEGFilter exampleJPEG.
```
"
Class {
	#name : 'StJPEGFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StJPEGFilter class >> exampleJPEG [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StJPEGFilter >> basename [
	^ 'JPEG'
]

{ #category : 'accessing' }
StJPEGFilter >> extensions [
	^ #('jpg' 'jpeg' 'jpe' 'jfif')
]
