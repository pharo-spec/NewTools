"
I represent a bookmark having location, icon, and a name.
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
