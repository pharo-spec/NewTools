"
i'm an Abstract class to group common file browser bookmarks behavior and state.

Subclasses must define:

- `isComposite` : Answer a `Boolean`

## Instance variables

- `icon`: `Form` 
- `name`: `String`
"
Class {
	#name : 'StFileBrowserAbstractBookMark',
	#superclass : 'Object',
	#instVars : [
		'name',
		'icon'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> children [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> icon [
	^ icon
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> icon: anObject [
	icon := anObject
]

{ #category : 'testing' }
StFileBrowserAbstractBookMark >> isComposite [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> name [
	^ name
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> name: anObject [
	name := anObject
]
