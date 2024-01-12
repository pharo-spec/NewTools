"
Abstract superclass to wrap items found in file system.

"
Class {
	#name : 'StFBFileSystemItemWrapper',
	#superclass : 'Object',
	#instVars : [
		'fileReference'
	],
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'accessing' }
StFBFileSystemItemWrapper class >> icon [ 
	^self iconProvider folderIcon 
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper class >> iconProvider [ 

	^ StFBIconCache 
]

{ #category : 'testing' }
StFBFileSystemItemWrapper class >> isAbstract [ 

	^self name = #HRBFileSystemItemWrapper
]

{ #category : 'instance creation' }
StFBFileSystemItemWrapper class >> on: aFileReference [

	^(self new)
		fileReference: aFileReference;
		yourself
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper class >> roots [

	^ Smalltalk os isWindows
		ifTrue: [ FileSystem root directories collect: [:each | StFBRootDriveWrapper on: each ] ]
		ifFalse: [ Array with: (StFBRootDirectoryWrapper on: FileSystem root) ]
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper class >> systemIcon [

	^self isAbstract ifTrue: [ super systemIcon ] ifFalse: [ self icon ]
]

{ #category : 'comparing' }
StFBFileSystemItemWrapper >> = aStFBFileSystemItemWrapper [

	self == aStFBFileSystemItemWrapper
		ifTrue: [ ^ true ].
	^ self class = aStFBFileSystemItemWrapper class and: [
			fileReference = aStFBFileSystemItemWrapper fileReference ]
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> allElements [  
	
	^(OrderedCollection withAll: self subdirectories) 
		addAll: self files; 
		yourself
]

{ #category : 'converting' }
StFBFileSystemItemWrapper >> asFileReference [ 

	^self fileReference
]

{ #category : 'actions' }
StFBFileSystemItemWrapper >> browseFolder [
	fileReference openInOSFileBrowser 
]

{ #category : 'private - accessing' }
StFBFileSystemItemWrapper >> directories [ 
	[ self fileReference directories ] on: Exception do: [ ^#()].
	^self fileReference directories
]

{ #category : 'private - accessing' }
StFBFileSystemItemWrapper >> fileReference [
	^ fileReference
]

{ #category : 'private - accessing' }
StFBFileSystemItemWrapper >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> files [ 
	
	^ [ fileReference files collect: [:each | StFBFileWrapper on: each ] ]
		on: FileException 
		do: [ #() ]
]

{ #category : 'comparing' }
StFBFileSystemItemWrapper >> hash [

	^ fileReference hash
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> icon [

	^ self class icon
]

{ #category : 'testing' }
StFBFileSystemItemWrapper >> isDirectory [

	^ false
]

{ #category : 'testing' }
StFBFileSystemItemWrapper >> isFile [

	^false
]

{ #category : 'testing' }
StFBFileSystemItemWrapper >> isRoot [ 
	^false
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> label [ 
	^self fileReference basename
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> pathString [
 
	| path |
	path := self fileReference fullPath pathString.
	^Smalltalk os isWindows ifTrue: [ path allButFirst copyReplaceAll: '/' with: '\' ]
		ifFalse: [ path ]
]

{ #category : 'printing' }
StFBFileSystemItemWrapper >> printOn: aStream [
	
	super printOn: aStream.
	aStream << ' ['.
	fileReference printOn: aStream.
	aStream << ']'.

]

{ #category : 'private - accessing' }
StFBFileSystemItemWrapper >> size [ 
	^''
]

{ #category : 'accessing' }
StFBFileSystemItemWrapper >> subdirectories [ 
	
	^ self directories collect: [:each | StFBDirectoryWrapper on: each ] 
]
