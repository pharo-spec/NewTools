"
I am the extension filter of PNG images, shown as 'PNG (*.png)'. I am one of the default filters; `StFileBrowserAbstractFilter` describes how filters are created and used, and `StExtensionsFilter` how extension filters work.

## Responsibility:

- Give the extensions of PNG images and the basename of my name.

## Collaborators:

- `StExtensionsFilter`: my superclass does the filtering, the name and the name completion.

## Public API and Key Messages

- `extensions`, `basename`.

## Examples

```smalltalk
StPNGFilter examplePNG.
```
"
Class {
	#name : 'StPNGFilter',
	#superclass : 'StExtensionsFilter',
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'examples' }
StPNGFilter class >> examplePNG [

	<sampleInstance>
	^ self new
]

{ #category : 'accessing' }
StPNGFilter >> basename [
	^ 'PNG'
]

{ #category : 'accessing' }
StPNGFilter >> extensions [
	^ #('png')
]
