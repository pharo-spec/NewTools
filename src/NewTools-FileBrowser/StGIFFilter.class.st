"
I am the extension filter of GIF images, shown as 'GIF (*.gif)'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used, and `StExtensionsFilter` how extension filters work.

## Responsibility:

- Give the extensions of GIF images and the basename of my name.

## Collaborators:

- `StExtensionsFilter`: my superclass does the filtering, the name and the name completion.

## Public API and Key Messages

- `extensions`, `basename`.

## Examples

```smalltalk
StGIFFilter exampleGIF.
```
"
Class {
	#name : 'StGIFFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StGIFFilter class >> exampleGIF [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StGIFFilter >> basename [
	^ 'GIF'
]

{ #category : 'accessing' }
StGIFFilter >> extensions [
	^ #('gif')
]
