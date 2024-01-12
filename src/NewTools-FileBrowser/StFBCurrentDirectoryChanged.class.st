Class {
	#name : 'StFBCurrentDirectoryChanged',
	#superclass : 'Announcement',
	#instVars : [
		'directory'
	],
	#category : 'NewTools-FileBrowser-Announcement',
	#package : 'NewTools-FileBrowser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
StFBCurrentDirectoryChanged class >> with: aFileReference [

	^ self new
		directory: aFileReference;
		yourself
]

{ #category : 'accessing' }
StFBCurrentDirectoryChanged >> directory [

	^ directory
]

{ #category : 'accessing' }
StFBCurrentDirectoryChanged >> directory: anObject [

	directory := anObject
]
