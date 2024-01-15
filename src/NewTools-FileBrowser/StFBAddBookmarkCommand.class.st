"
I'm a command use to add bookmark
"
Class {
	#name : 'StFBAddBookmarkCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBAddBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : 'testing' }
StFBAddBookmarkCommand >> canBeExecuted [
	^ self context selectedEntry isDirectory
]

{ #category : 'executing' }
StFBAddBookmarkCommand >> execute [
	| fileReference |

	fileReference := self context selectedEntry.
	self context addBookmark: fileReference.
	self flag: #todo.	"We can do better here."
	self context bookmarksTreeTable roots: self context bookmarks
]

{ #category : 'initialization' }
StFBAddBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Add to bookmarks';
		description: 'Add the selected file to the bookmarks.'
]
