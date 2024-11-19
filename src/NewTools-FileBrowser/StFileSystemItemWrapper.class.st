"
Abstract superclass to wrap items found in file system.

"
Class {
	#name : 'StFileSystemItemWrapper',
	#superclass : 'Object',
	#instVars : [
		'fileReference'
	],
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'accessing' }
StFileSystemItemWrapper class >> icon [ 
	^self iconProvider folderIcon 
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> iconProvider [ 

	^ StFileBrowserIconCache 
]

{ #category : 'testing' }
StFileSystemItemWrapper class >> isAbstract [ 

	^self name = #HRBFileSystemItemWrapper
]

{ #category : 'instance creation' }
StFileSystemItemWrapper class >> on: aFileReference [

	^(self new)
		fileReference: aFileReference;
		yourself
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> roots [

	^ Smalltalk os isWindows
		  ifTrue: [
			  FileSystem root directories
				  select: [ :each | each exists and: [ each isReadable ] ]
				  thenCollect: [ :each | StRootDriveWrapper on: each ] ]
		  ifFalse: [
		  Array with: (StRootDirectoryWrapper on: FileSystem root) ]
]

{ #category : 'accessing' }
StFileSystemItemWrapper class >> systemIcon [

	^self isAbstract ifTrue: [ super systemIcon ] ifFalse: [ self icon ]
]

{ #category : 'comparing' }
StFileSystemItemWrapper >> = aStFBFileSystemItemWrapper [

	self == aStFBFileSystemItemWrapper
		ifTrue: [ ^ true ].
	^ self class = aStFBFileSystemItemWrapper class and: [
			fileReference = aStFBFileSystemItemWrapper fileReference ]
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> allElements [  
	
	^(OrderedCollection withAll: self subdirectories) 
		addAll: self files; 
		yourself
]

{ #category : 'converting' }
StFileSystemItemWrapper >> asFileReference [ 

	^self fileReference
]

{ #category : 'actions' }
StFileSystemItemWrapper >> browseFolder [
	fileReference openInOSFileBrowser 
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> directories [ 

	^ [ self fileReference directories sorted: [ :a :b | a basename caseInsensitiveLessOrEqual: b basename ] ]
		on: Exception do: [ #() ]
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> fileReference [
	^ fileReference
]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> files [ 
	
	^ [ fileReference files
			collect: [:each | StFileWrapper on: each ] ]
		on: FileException 
		do: [ #() ]
]

{ #category : 'comparing' }
StFileSystemItemWrapper >> hash [

	^ fileReference hash
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> icon [

	^ self class icon
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isDirectory [

	^ false
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isFile [

	^false
]

{ #category : 'testing' }
StFileSystemItemWrapper >> isRoot [ 
	^false
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> label [

	^ self fileReference basename
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> pathString [
 
	| path |
	path := self fileReference fullPath pathString.
	^Smalltalk os isWindows ifTrue: [ path allButFirst copyReplaceAll: '/' with: '\' ]
		ifFalse: [ path ]
]

{ #category : 'printing' }
StFileSystemItemWrapper >> printOn: aStream [
	
	super printOn: aStream.
	aStream << ' ['.
	fileReference printOn: aStream.
	aStream << ']'.

]

{ #category : 'private - accessing' }
StFileSystemItemWrapper >> size [ 
	^''
]

{ #category : 'accessing' }
StFileSystemItemWrapper >> subdirectories [ 
	
	^ self directories collect: [:each | StDirectoryWrapper on: each ] 
]
