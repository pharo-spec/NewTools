"
I add the selected folder to the shared bookmarks ('Add to bookmarks', file table menu). I can only run on a directory.
"
Class {
	#name : 'StFileBrowserAddBookmarkCommand',
	#superclass : 'StFileBrowserBookmarkCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserAddBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : 'testing' }
StFileBrowserAddBookmarkCommand >> canBeExecuted [
	^ self context selectedEntry isDirectory
]

{ #category : 'executing' }
StFileBrowserAddBookmarkCommand >> execute [
	| fileReference |

	fileReference := self context selectedEntry.
	self context addBookmark: fileReference.
	self bookmarksTreeTable
		roots: self context bookmarks;
		expandRoots

]

{ #category : 'initialization' }
StFileBrowserAddBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Add to bookmarks';
		description: 'Add the selected file to the bookmarks.'
]
