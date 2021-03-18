"
I'm a command use to add bookmark
"
Class {
	#name : #StFBAddBookmarkCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileBrowser-Commands'
}

{ #category : #converting }
StFBAddBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : #testing }
StFBAddBookmarkCommand >> canBeExecuted [
	^ self context selectedEntry isDirectory
]

{ #category : #executing }
StFBAddBookmarkCommand >> execute [
	| fileReference |
	fileReference := self context selectedEntry.
	self context owner bookmarks add: (StFBBookmark name: fileReference basename location: fileReference icon: nil).
	self flag: #todo.	"We can do better here."
	self context owner bookmarksTreeTable roots: self context owner bookmarks
]

{ #category : #initialization }
StFBAddBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Add to bookmarks';
		description: 'Add the selected file to the bookmarks.'
]
