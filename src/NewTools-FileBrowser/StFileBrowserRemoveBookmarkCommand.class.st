"
I'm a command use to remove bookmark


"
Class {
	#name : 'StFileBrowserRemoveBookmarkCommand',
	#superclass : 'CmCommand',
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

{ #category : 'executing' }
StFileBrowserRemoveBookmarkCommand >> execute [
	| collection tmpBookmark collectionSize |
	collection := self context bookmarksTreeTable selection selectedPath.
	collectionSize := collection size."teta(N)"
	tmpBookmark := self context bookmarks.
 	[collectionSize = 1  ] whileFalse: [ tmpBookmark := tmpBookmark at: (collection at: 1).collectionSize := collectionSize  -1  ].
	tmpBookmark removeAt: (collection at:  1).
	self context bookmarksTreeTable roots: self context bookmarks 
]

{ #category : 'initialization' }
StFileBrowserRemoveBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Remove bookmark';
		description: 'Remove the selected bookmark'
]
