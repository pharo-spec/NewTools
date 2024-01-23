"
I'm a command use to remove bookmark


"
Class {
	#name : 'StFileBrowserRemoveBookmarkCommand',
	#superclass : 'StFileBrowserBookmarkCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserRemoveBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #remotesManagerRemoveRemote;
		yourself
]

{ #category : 'testing' }
StFileBrowserRemoveBookmarkCommand >> canBeExecuted [

	^ self selectedBookmarks selectedPaths notEmpty
]

{ #category : 'executing' }
StFileBrowserRemoveBookmarkCommand >> execute [

	| collection tmpBookmark collectionSize |

	collection := self selectedBookmarks selectedPath.
	collectionSize := collection size. "teta(N)"
	tmpBookmark := self context bookmarks.
	[ collectionSize = 1 ] whileFalse: [
		tmpBookmark := tmpBookmark at: (collection at: 1).
		collectionSize := collectionSize - 1 ].
	tmpBookmark removeAt: (collection at: 1).
	self bookmarksTreeTable 
		roots: self context bookmarks;
		expandRoots
]

{ #category : 'initialization' }
StFileBrowserRemoveBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Remove bookmark';
		description: 'Remove the selected bookmark'
]

{ #category : 'executing' }
StFileBrowserRemoveBookmarkCommand >> selectedBookmarks [

	^ self bookmarksTreeTable selection
]
