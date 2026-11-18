"
I am the root of the bookmarks shown in the left pane of the file dialogs. A bookmark gives quick access to a folder; bookmarks are organized as a tree: a `StFileBrowserGroupBookmark` is a named node holding `StFileBrowserBookmark` leaves, each one pointing to a folder.

## Life cycle: who creates bookmarks and who uses them

1. **The default bookmarks are created once and shared.** `StFileSystemModel class>>bookmarks` lazily calls `initializeBookmarks`, which asks `StFileBrowserBookmark class>>defaultBookmarks` for a collection with one group, 'Bookmarks', holding a bookmark for each drive root (from `StFileSystemItemWrapper roots`) and for the home, working, desktop, documents and downloads folders. The collection is kept in the `Bookmarks` class variable of `StFileSystemModel`: all file dialogs share it. `StFileSystemModel>>initialize` rebuilds it when it is empty and `StFileBrowserSettings showAlwaysDefaultBookmarks` is set.
2. **The dialog shows them.** `StFileSystemPresenter>>initializeBookmarksTreeTable` shows the bookmarks as the roots of a tree table, with my `icon` and `name`, and my `children` as subnodes. Selecting a bookmark that is not composite opens its `location` in the navigation presenter.
3. **The user adds and removes bookmarks** with the context menu commands. `StFileBrowserAddBookmarkCommand` calls `StFileSystemModel>>addBookmark:`, which creates a `StFileBrowserBookmark` named after the selected folder at the top level of the shared collection. `StFileBrowserRemoveBookmarkCommand` removes the selected bookmark with `removeAt:` on its group (or on the top-level collection).
4. **Code customizes them.** `aDialog bookmarks: { aGroup }` replaces the bookmarks shown by one dialog (as `StOpenFilePresenter class>>#complexExampleTextPreviewer` does), and `StFileSystemModel addBookmarkNamed:location:iconName:` adds a bookmark to the first shared group.

## Responsibility:

- Know my name and my icon, displayed in the bookmark tree.
- Tell whether I am a group (`isComposite`) and answer my `children`, so that the tree can show me.

## Collaborators:

- `StFileSystemModel`: creates and keeps the shared bookmarks.
- `StFileSystemPresenter`: shows the bookmarks in its tree table and opens the folder of the selected one.
- `StFileBrowserAddBookmarkCommand` and `StFileBrowserRemoveBookmarkCommand`: add and remove bookmarks from the tree context menu.

## Public API and Key Messages

- `name`, `name:`: the label in the tree.
- `icon`, `icon:`: the `Form` displayed before the label.
- `isComposite`: true for a group. Subclasses define it.
- `children`: the subnodes in the tree. Subclasses define it.

## Examples

```smalltalk
StFileBrowserAbstractBookMark scriptDefaultBookmarksTree.
```

It opens the default bookmarks in a tree, as a file dialog shows them.

## Internal Representation

- `name`: a `String`.
- `icon`: a `Form`.
"
Class {
	#name : 'StFileBrowserAbstractBookMark',
	#superclass : 'Object',
	#instVars : [
		'name',
		'icon'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'script' }
StFileBrowserAbstractBookMark class >> scriptDefaultBookmarksTree [
	"Opens the default bookmarks of the file dialogs in a tree, as the bookmark pane of a dialog shows them: a group holding a bookmark for each drive and for the usual folders."

	<example>
	| tree |
	tree := SpEasyTreeListViewPresenter new
		        roots: StFileBrowserBookmark defaultBookmarks;
		        children: [ :bookmark | bookmark children ];
		        displayIcon: [ :bookmark | bookmark icon ];
		        display: [ :bookmark | bookmark name ];
		        expandRoots;
		        yourself.
	^ tree open
		  title: 'Default bookmarks';
		  yourself
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> children [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> icon [
	^ icon
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> icon: anObject [
	icon := anObject
]

{ #category : 'testing' }
StFileBrowserAbstractBookMark >> isComposite [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> name [
	^ name
]

{ #category : 'accessing' }
StFileBrowserAbstractBookMark >> name: anObject [
	name := anObject
]
