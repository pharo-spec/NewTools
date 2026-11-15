"
I test the bookmarks of the file dialogs: `StFileBrowserBookmark` (one folder) and `StFileBrowserGroupBookmark` (a named group of bookmarks).

## Responsibility:

- Check that a bookmark is a leaf of the bookmark tree and a group is a node whose children are its bookmarks.
- Check that bookmarks can be added to and removed from a group.
- Check that bookmarks with the same name, location and icon are equal.

## Collaborators:

- `StFileBrowserBookmark class >> #exampleHome` and `StFileBrowserGroupBookmark class >> #examplePharoFolders`: the instances under test.
"
Class {
	#name : 'StFileBrowserBookmarkTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FileBrowser-Tests-Bookmark',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Bookmark'
}

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testBookmarkIsALeaf [

	| bookmark |
	bookmark := StFileBrowserBookmark exampleHome.
	self deny: bookmark isComposite.
	self assertEmpty: bookmark children.
	self assert: bookmark location equals: FileLocator home
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testBookmarksWithAnotherLocationAreDifferent [

	self
		deny: StFileBrowserBookmark exampleHome
		equals: (StFileBrowserBookmark name: 'Home' location: FileLocator workingDirectory icon: StFileBrowserBookmark exampleHome icon)
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testBookmarksWithSameNameLocationAndIconAreEqual [

	self assert: StFileBrowserBookmark exampleHome equals: StFileBrowserBookmark home.
	self assert: StFileBrowserBookmark exampleHome hash equals: StFileBrowserBookmark home hash
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testCopyOfAGroupHasItsOwnBookmarks [

	| group copy |
	group := StFileBrowserGroupBookmark examplePharoFolders.
	copy := group copy.
	copy addBookmark: StFileBrowserBookmark exampleHome.
	self assert: group children size equals: 2.
	self assert: copy children size equals: 3
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testGroupAddBookmark [

	| group |
	group := StFileBrowserGroupBookmark examplePharoFolders.
	group addBookmark: StFileBrowserBookmark exampleHome.
	self assert: group children last equals: StFileBrowserBookmark exampleHome
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testGroupChildrenAreItsBookmarks [

	| group |
	group := StFileBrowserGroupBookmark examplePharoFolders.
	self assert: group isComposite.
	self assert: (group children collect: [ :each | each name ] as: Array) equals: #( 'Image directory' 'Working directory' )
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testGroupRemoveAt [

	| group |
	group := StFileBrowserGroupBookmark examplePharoFolders.
	group removeAt: 1.
	self assert: (group children collect: [ :each | each name ] as: Array) equals: #( 'Working directory' )
]

{ #category : 'tests' }
StFileBrowserBookmarkTest >> testSampleInstancesAnswerBookmarks [

	self assert: StFileBrowserBookmark exampleHome class identicalTo: StFileBrowserBookmark.
	self assert: StFileBrowserGroupBookmark examplePharoFolders class identicalTo: StFileBrowserGroupBookmark
]
