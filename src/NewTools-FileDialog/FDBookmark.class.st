"
I represent a bookmark having location, icon, and a name.
"
Class {
	#name : #FDBookmark,
	#superclass : #FDAbstractBookMark,
	#instVars : [
		'location'
	],
	#category : #'NewTools-FileDialog-Bookmark'
}

{ #category : #defaultClassVariable }
FDBookmark class >> defaultBookmarks [
	| presets |
	presets := OrderedCollection withAll: {self root . self home . self workingDirectory . self desktop . self documents . self downloads}.
	^ OrderedCollection with: (FDGroupBookmark name: 'Favourites' collection: presets iconName: '')
]

{ #category : #'default bookmarks' }
FDBookmark class >> desktop [
	^ self
		name: 'Desktop'
		location: FileLocator desktop
		icon: (self iconNamed: #morph)
]

{ #category : #'default bookmarks' }
FDBookmark class >> documents [
	^ self
		name: 'Documents'
		location: FileLocator documents
		icon: (self iconNamed: #book)
]

{ #category : #'default bookmarks' }
FDBookmark class >> downloads [
	^ self
		name: 'Downloads'
		location: FileLocator downloads
		icon: (self iconNamed: #down)
]

{ #category : #'default bookmarks' }
FDBookmark class >> home [
	^ self
		name: 'Home'
		location: FileLocator home
		icon: (self iconNamed: #home)
]

{ #category : #'default bookmarks' }
FDBookmark class >> image [
	^ self
		name: 'Image directory'
		location: FileLocator imageDirectory
		icon: (self iconNamed: #komitterNewSlice)
]

{ #category : #'instance creation' }
FDBookmark class >> name: aName location: aLocation icon: anIcon [
	^ self new
		name: aName;
		location: aLocation;
		icon: anIcon;
		yourself
]

{ #category : #'default bookmarks' }
FDBookmark class >> root [
	^ self
		name: '/'
		location: FileLocator root
		icon: (self iconNamed: #smallWindow)
]

{ #category : #'default bookmarks' }
FDBookmark class >> tmp [
	^ FDBookmark
		name: 'tmp'
		location: FileLocator temp asFileReference
		icon: Smalltalk ui icons open
]

{ #category : #'default bookmarks' }
FDBookmark class >> windowsDrives [
	^ FileLocator root asFileReference directories
		collect:
			[ :each | FDBookmark name: each basename location: each icon: Smalltalk ui icons smallWindow ]
]

{ #category : #'default bookmarks' }
FDBookmark class >> workingDirectory [
	^ self
		name: 'Working directory'
		location: FileLocator workingDirectory
		icon: (self iconNamed: #komitterNewSlice) 
]

{ #category : #comparing }
FDBookmark >> = aBookmark [
	self species = aBookmark species
		ifFalse: [ ^ false ].
	^ self icon = aBookmark icon & (self location = aBookmark location)
		& (self name = aBookmark name)
]

{ #category : #accessing }
FDBookmark >> children [ 
	^ {  }
]

{ #category : #comparing }
FDBookmark >> hash [
	^ (self icon hash bitXor: self location hash) bitXor: self name hash
]

{ #category : #accessing }
FDBookmark >> icon [
	^ icon
]

{ #category : #accessing }
FDBookmark >> icon: anIcon [
	icon := anIcon
]

{ #category : #testing }
FDBookmark >> isComposite [
	^ false
]

{ #category : #accessing }
FDBookmark >> location [
	^ location
]

{ #category : #accessing }
FDBookmark >> location: aFileReference [
	location := aFileReference
]

{ #category : #accessing }
FDBookmark >> name [
	^ name
]

{ #category : #accessing }
FDBookmark >> name: aString [
	name := aString
]

{ #category : #printing }
FDBookmark >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< name;
		<< '''->''';
		<< location fullName;
		<< ''')'
]
