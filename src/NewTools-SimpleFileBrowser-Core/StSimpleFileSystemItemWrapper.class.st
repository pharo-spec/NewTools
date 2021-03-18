"
Abstract superclass to wrap items found in file system
"
Class {
	#name : #StSimpleFileSystemItemWrapper,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #'NewTools-SimpleFileBrowser-Core'
}

{ #category : #accessing }
StSimpleFileSystemItemWrapper class >> icon [ 
	^self iconProvider folderIcon 
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper class >> iconProvider [ 

	^StSimpleIconCache 
]

{ #category : #testing }
StSimpleFileSystemItemWrapper class >> isAbstract [ 

	^self name = #StSimpleFileSystemItemWrapper
]

{ #category : #'instance creation' }
StSimpleFileSystemItemWrapper class >> on: aFileReference [

	^(self new)
		fileReference: aFileReference;
		yourself
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper class >> roots [

	^ Smalltalk os isWindows
		ifTrue: [ FileSystem root directories collect: [:each | StSimpleRootDriveWrapper on: each ]]
		ifFalse: [ Array with: (StSimpleRootDirectoryWrapper on: FileSystem root) ]
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper class >> systemIcon [

	^self isAbstract ifTrue: [ super systemIcon ] ifFalse: [ self icon ]
]

{ #category : #comparing }
StSimpleFileSystemItemWrapper >> = other [

	^ self species = other species 
		and: [ self fileReference = other fileReference ]
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> allElements [  
	
	^(OrderedCollection withAll: self subdirectories) 
		addAll: self files; 
		yourself
]

{ #category : #conversion }
StSimpleFileSystemItemWrapper >> asFileReference [ 

	^self fileReference
]

{ #category : #actions }
StSimpleFileSystemItemWrapper >> browseFolder [
	fileReference openInOSFileBrowser 
]

{ #category : #'private - accessing' }
StSimpleFileSystemItemWrapper >> directories [ 
	[ self fileReference directories ] on: Exception do: [ ^#()].
	^self fileReference directories
]

{ #category : #'private - accessing' }
StSimpleFileSystemItemWrapper >> fileReference [
	^ fileReference
]

{ #category : #'private - accessing' }
StSimpleFileSystemItemWrapper >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> files [ 
	
	^[fileReference files collect: [:each | StSimpleFileWrapper on: each ] ]
		on: FileException 
		do: [ #() ]
]

{ #category : #comparing }
StSimpleFileSystemItemWrapper >> hash [

	^ self species hash 
		bitXor: self fileReference hash
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> icon [

	^self class icon
]

{ #category : #testing }
StSimpleFileSystemItemWrapper >> isDirectory [

	^false
]

{ #category : #testing }
StSimpleFileSystemItemWrapper >> isFile [

	^false
]

{ #category : #testing }
StSimpleFileSystemItemWrapper >> isRoot [ 
	^false
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> label [ 
	^self fileReference basename
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> pathString [
 
	| path |
	path := self fileReference fullPath pathString.
	^Smalltalk os isWindows ifTrue: [ path allButFirst copyReplaceAll: '/' with: '\' ]
		ifFalse: [ path ]
]

{ #category : #'private - accessing' }
StSimpleFileSystemItemWrapper >> size [ 
	^''
]

{ #category : #accessing }
StSimpleFileSystemItemWrapper >> subdirectories [ 
	
	^self directories collect: [:each | StSimpleDirectoryWrapper on: each ] 
]
