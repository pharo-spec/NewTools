"
Abstract class to group behavior related with the file browser bookmarks.

"
Class {
	#name : 'StFileBrowserBookmarkCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StFileBrowserBookmarkCommand >> bookmarksTreeTable [

	^ self context bookmarksTreeTable
]
