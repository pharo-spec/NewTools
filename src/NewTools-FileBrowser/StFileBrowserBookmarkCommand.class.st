"
I am the abstract root of the bookmark commands. I give them the bookmark tree of their context (`bookmarksTreeTable`). `StFileBrowserAbstractBookMark` describes how bookmarks are kept.
"
Class {
	#name : 'StFileBrowserBookmarkCommand',
	#superclass : 'StFileBrowserCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StFileBrowserBookmarkCommand >> bookmarksTreeTable [

	^ self context bookmarksTreeTable
]
