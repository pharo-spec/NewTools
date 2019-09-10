"
I'm a command use to remove bookmark


"
Class {
	#name : #FDRemoveBookmarkCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileDialog-Commands'
}

{ #category : #converting }
FDRemoveBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #remotesManagerRemoveRemote;
		yourself
]

{ #category : #hooks }
FDRemoveBookmarkCommand >> execute [
	| collection tmpBookmark collectionSize |
	collection := self context bookmarksTreeTable selection selectedPath.
	collectionSize := collection size."teta(N)"
	tmpBookmark := self context bookmarks.
 	[collectionSize = 1  ] whileFalse: [ tmpBookmark := tmpBookmark at: (collection at: 1).collectionSize := collectionSize  -1  ].
	tmpBookmark removeAt: (collection at:  1).
	self context bookmarksTreeTable roots: self context bookmarks 
]

{ #category : #initialization }
FDRemoveBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Remove';
		description: 'Remove the selected bookmark'
]
