"
I'm a command use to add bookmark
"
Class {
	#name : #FDAddBookmarkCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileDialog-Commands'
}

{ #category : #converting }
FDAddBookmarkCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : #testing }
FDAddBookmarkCommand >> canBeExecuted [
	^ self context selectedEntry isDirectory
]

{ #category : #executing }
FDAddBookmarkCommand >> execute [
	| fileReference |
	fileReference := self context selectedEntry.
	self context owner bookmarks add: (FDBookmark name: fileReference basename location: fileReference icon: nil).
	self flag: #todo.	"We can do better here."
	self context owner bookmarksTreeTable roots: self context owner bookmarks
]

{ #category : #initialization }
FDAddBookmarkCommand >> initialize [
	super initialize.
	self
		name: 'Add to bookmarks';
		description: 'Add the selected file to the bookmarks.'
]
