"
Abstract class to group behavior related with selections in the File Browser tool.

"
Class {
	#name : 'StFBSelectionCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'executing' }
StFBSelectionCommand >> application [

	^ self context application
]

{ #category : 'accessing' }
StFBSelectionCommand >> currentDirectory [ 
	"Answer a <FileReference> with the receiver's current directory"

	^ self context currentDirectory 
]

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntry [

	^ self context selectedEntry 
]

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntryBasename [
	"Answer a <String> with the basename of the selected entry"

	^ self selectedEntry basename
]

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntryName [

	^ self selectedEntry name
]

{ #category : 'utils' }
StFBSelectionCommand >> updateFileSystemContents [
	"Update the receiver's file navigation table"

	self context updateFileSystemContents
]
