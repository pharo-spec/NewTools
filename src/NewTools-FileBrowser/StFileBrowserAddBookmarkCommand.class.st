"
I'm a command use to add bookmark
"
Class {
	#name : 'StFileBrowserAddBookmarkCommand',
	#superclass : 'CmCommand',
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
	self context bookmarksTreeTableItems: self context bookmarks
]

{ #category : 'initialization' }
StFileBrowserAddBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Add to bookmarks';
		description: 'Add the selected file to the bookmarks.'
]
