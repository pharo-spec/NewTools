"
I am a bookmark on one folder: a leaf of the bookmark tree. `StFileBrowserAbstractBookMark` describes how bookmarks are created and used; here is what is specific to me.

## Responsibility:

- Know the folder I point to (`location`).
- Create the usual bookmarks (home, working directory, image directory, desktop, documents, downloads, temporary folder) and the default bookmarks of the file dialogs (`defaultBookmarks`).

## Collaborators:

- `StFileSystemModel`: gets the default bookmarks from me (`initializeBookmarks`) and creates a bookmark of mine for each folder the user bookmarks (`addBookmark:`).
- `StFileSystemPresenter`: opens my `location` when I am selected.
- `FileLocator` / `FileReference`: my location; the usual bookmarks use a `FileLocator`, so they follow the current machine.

## Public API and Key Messages

- `StFileBrowserBookmark name: aString location: aFileLocator icon: aForm`: a new bookmark.
- `StFileBrowserBookmark home`, `workingDirectory`, `image`, `desktop`, `documents`, `downloads`, `tmp`: the usual bookmarks.
- `StFileBrowserBookmark defaultBookmarks`: a collection with one 'Bookmarks' group of drive and usual bookmarks.
- `location`: the folder I point to.

Two bookmarks are equal when they have the same name, location and icon.

## Examples

```smalltalk
StFileBrowserBookmark exampleHome.
```

It answers the 'Home' bookmark on `FileLocator home` (checked by `StFileBrowserBookmarkTest`).

## Internal Representation

- `location`: a `FileLocator` or a `FileReference`.
"
Class {
	#name : 'StFileBrowserBookmark',
	#superclass : 'StFileBrowserAbstractBookMark',
	#instVars : [
		'location'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> createDriveBookmarks [

	^ StFileSystemItemWrapper roots
		  collect: [ :each |
			  self
				  name: each label
				  location: each asFileReference
				  icon: each icon ]
		  as: OrderedCollection
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> defaultBookmarks [

	| presets |
	presets := self createDriveBookmarks , {
		           self home.
		           self workingDirectory.
		           self desktop.
		           self documents.
		           self downloads }.

	^ OrderedCollection with: (StFileBrowserGroupBookmark
			   name: 'Bookmarks'
			   collection: presets
			   iconName: #book)
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> desktop [
	^ self
		name: 'Desktop'
		location: FileLocator desktop
		icon: (self iconNamed: #morph)
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> documents [
	^ self
		name: 'Documents'
		location: FileLocator documents
		icon: (self iconNamed: #book)
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> downloads [
	^ self
		name: 'Downloads'
		location: FileLocator downloads
		icon: (self iconNamed: #down)
]

{ #category : 'examples' }
StFileBrowserBookmark class >> exampleHome [

	<sampleInstance>
	^ self home
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> home [
	^ self
		name: 'Home'
		location: FileLocator home
		icon: (self iconNamed: #home)
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> image [
	^ self
		name: 'Image directory'
		location: FileLocator imageDirectory
		icon: (self iconNamed: #komitterNewSlice)
]

{ #category : 'instance creation' }
StFileBrowserBookmark class >> name: aName location: aLocation icon: anIcon [
	^ self new
		name: aName;
		location: aLocation;
		icon: anIcon;
		yourself
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> tmp [
	^ StFileBrowserBookmark
		name: 'tmp'
		location: FileLocator temp asFileReference
		icon: (self iconNamed: #book)
]

{ #category : 'default bookmarks' }
StFileBrowserBookmark class >> workingDirectory [
	^ self
		name: 'Working directory'
		location: FileLocator workingDirectory
		icon: (self iconNamed: #komitterNewSlice) 
]

{ #category : 'comparing' }
StFileBrowserBookmark >> = aBookmark [
	self species = aBookmark species
		ifFalse: [ ^ false ].
	^ self icon = aBookmark icon & (self location = aBookmark location)
		& (self name = aBookmark name)
]

{ #category : 'accessing' }
StFileBrowserBookmark >> children [ 
	^ {  }
]

{ #category : 'comparing' }
StFileBrowserBookmark >> hash [
	^ (self icon hash bitXor: self location hash) bitXor: self name hash
]

{ #category : 'accessing' }
StFileBrowserBookmark >> icon: anIcon [
	icon := anIcon
]

{ #category : 'testing' }
StFileBrowserBookmark >> isComposite [
	^ false
]

{ #category : 'accessing' }
StFileBrowserBookmark >> location [
	^ location
]

{ #category : 'accessing' }
StFileBrowserBookmark >> location: aFileReference [
	location := aFileReference
]

{ #category : 'accessing' }
StFileBrowserBookmark >> name: aString [
	name := aString
]

{ #category : 'printing' }
StFileBrowserBookmark >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< name;
		<< '''->''';
		<< location fullName;
		<< ''')'
]
