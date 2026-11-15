"
I am a named group of bookmarks: a node of the bookmark tree, shown with my bookmarks below me. The default bookmarks of the file dialogs are one group of mine, 'Bookmarks'. `StFileBrowserAbstractBookMark` describes how bookmarks are created and used; here is what is specific to me.

## Responsibility:

- Hold an ordered collection of bookmarks, answered as my `children`.
- Add and remove bookmarks.

## Collaborators:

- `StFileBrowserBookmark class>>defaultBookmarks`: creates the default 'Bookmarks' group.
- `StFileSystemModel class>>addBookmarkNamed:location:iconName:`: adds a bookmark to the first shared group.
- `StFileBrowserRemoveBookmarkCommand`: removes the selected bookmark from its group (`removeAt:`).

## Public API and Key Messages

- `StFileBrowserGroupBookmark name: aString collection: aCollection iconName: aSymbol`: a new group.
- `addBookmark: aBookmark`, `removeAt: anIndex`: change my bookmarks.
- `collection`, `children`: my bookmarks.

## Examples

```smalltalk
StFileBrowserGroupBookmark examplePharoFolders.
```

It answers a 'Pharo' group with the image directory and working directory bookmarks (checked by `StFileBrowserBookmarkTest`).

## Internal Representation

- `collection`: an `OrderedCollection` of bookmarks, so that bookmarks can be added and removed.
"
Class {
	#name : 'StFileBrowserGroupBookmark',
	#superclass : 'StFileBrowserAbstractBookMark',
	#instVars : [
		'collection'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'examples' }
StFileBrowserGroupBookmark class >> examplePharoFolders [

	<sampleInstance>
	^ self
		  name: 'Pharo'
		  collection: (OrderedCollection with: StFileBrowserBookmark image with: StFileBrowserBookmark workingDirectory)
		  iconName: #book
]

{ #category : 'instance creation' }
StFileBrowserGroupBookmark class >> name: aName collection: aCollection iconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : 'adding' }
StFileBrowserGroupBookmark >> addBookmark: aBookmark [

	self collection add: aBookmark
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> children [ 
	^ collection
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> collection [
	^ collection
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> collection: anObject [
	collection := anObject
]

{ #category : 'testing' }
StFileBrowserGroupBookmark >> isComposite [
	^ true
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> removeAt: anInteger [ 
	self collection removeAt: anInteger.
]
