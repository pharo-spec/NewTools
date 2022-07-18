"
I represent a bookmark having location, icon, and a name.
"
Class {
	#name : #StFBBookmark,
	#superclass : #StFBAbstractBookMark,
	#instVars : [
		'location'
	],
	#category : #'NewTools-FileBrowser-Bookmark'
}

{ #category : #defaultClassVariable }
StFBBookmark class >> defaultBookmarks [

	| presets |
	presets := (Smalltalk os isWindows
		           ifTrue: [ self windowsDrives ]
		           ifFalse: [ { self root } ]) asOrderedCollection.
	self flag:
		'desktop disabled until https://github.com/pharo-project/pharo/issues/9682 is fixed'.
	presets addAll: { 
			self home.
			self workingDirectory.
			"self desktop."
			self documents.
			self downloads }.

	^ OrderedCollection with:
		  (StFBGroupBookmark
			   name: 'Favourites'
			   collection: presets
			   iconName: '')
]

{ #category : #'default bookmarks' }
StFBBookmark class >> desktop [
	^ self
		name: 'Desktop'
		location: FileLocator desktop
		icon: (self iconNamed: #morph)
]

{ #category : #'default bookmarks' }
StFBBookmark class >> documents [
	^ self
		name: 'Documents'
		location: FileLocator documents
		icon: (self iconNamed: #book)
]

{ #category : #'default bookmarks' }
StFBBookmark class >> downloads [
	^ self
		name: 'Downloads'
		location: FileLocator downloads
		icon: (self iconNamed: #down)
]

{ #category : #'default bookmarks' }
StFBBookmark class >> home [
	^ self
		name: 'Home'
		location: FileLocator home
		icon: (self iconNamed: #home)
]

{ #category : #'default bookmarks' }
StFBBookmark class >> image [
	^ self
		name: 'Image directory'
		location: FileLocator imageDirectory
		icon: (self iconNamed: #komitterNewSlice)
]

{ #category : #'instance creation' }
StFBBookmark class >> name: aName location: aLocation icon: anIcon [
	^ self new
		name: aName;
		location: aLocation;
		icon: anIcon;
		yourself
]

{ #category : #'default bookmarks' }
StFBBookmark class >> root [

	^ self
		  name: '/'
		  location: FileLocator root
		  icon: (self iconNamed: #smallWindow)
]

{ #category : #'default bookmarks' }
StFBBookmark class >> tmp [
	^ StFBBookmark
		name: 'tmp'
		location: FileLocator temp asFileReference
		icon: Smalltalk ui icons open
]

{ #category : #'default bookmarks' }
StFBBookmark class >> windowsDrives [

	^ FileLocator root asFileReference directories collect: [ :each | 
		  self
			  name: each basename
			  location: each
			  icon: Smalltalk ui icons smallWindow ]
]

{ #category : #'default bookmarks' }
StFBBookmark class >> workingDirectory [
	^ self
		name: 'Working directory'
		location: FileLocator workingDirectory
		icon: (self iconNamed: #komitterNewSlice) 
]

{ #category : #comparing }
StFBBookmark >> = aBookmark [
	self species = aBookmark species
		ifFalse: [ ^ false ].
	^ self icon = aBookmark icon & (self location = aBookmark location)
		& (self name = aBookmark name)
]

{ #category : #accessing }
StFBBookmark >> children [ 
	^ {  }
]

{ #category : #comparing }
StFBBookmark >> hash [
	^ (self icon hash bitXor: self location hash) bitXor: self name hash
]

{ #category : #accessing }
StFBBookmark >> icon [
	^ icon
]

{ #category : #accessing }
StFBBookmark >> icon: anIcon [
	icon := anIcon
]

{ #category : #testing }
StFBBookmark >> isComposite [
	^ false
]

{ #category : #accessing }
StFBBookmark >> location [
	^ location
]

{ #category : #accessing }
StFBBookmark >> location: aFileReference [
	location := aFileReference
]

{ #category : #accessing }
StFBBookmark >> name [
	^ name
]

{ #category : #accessing }
StFBBookmark >> name: aString [
	name := aString
]

{ #category : #printing }
StFBBookmark >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< name;
		<< '''->''';
		<< location fullName;
		<< ''')'
]
