"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : 'StOpenFilePresenter',
	#superclass : 'StOpenFileOrDirectoryPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'example' }
StOpenFilePresenter class >> complexExampleAdaptivePreviewer [

	<example>
	| presenter |
	presenter := self new.
	presenter filter: (StCustomExtensionsFilter extensions: #( '.image' )).
	"you can add 1 own filter"

	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"

	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "

	presenter bookmarks: { (StFileBrowserGroupBookmark
			 name: 'exampleGroup'
			 collection: { 
					 StFileBrowserBookmark image.
					 StFileBrowserBookmark home }
			 iconName: 'group') }.
	"you define the bookmarks have to be instance of FDAbstractBookMark"

	presenter columns: { StFileBrowserCreationDateColumn }.

	presenter inspect.
	presenter openModal.
	presenter resetBookmarks.
	^ presenter confirm
]

{ #category : 'example' }
StOpenFilePresenter class >> complexExampleTextPreviewer [

	<example>
	| presenter |
	presenter := self new.

	presenter previewer: StFileBrowserTextBasedPreviewer new.
	"with this when you select a png file it will display it"

	presenter filter: (StCustomExtensionsFilter extensions: #( '.image' )).
	"you can add 1 own filter"

	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"

	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "

	presenter bookmarks: { (StFileBrowserGroupBookmark
			 name: 'exampleGroup'
			 collection: { 
					 StFileBrowserBookmark image.
					 StFileBrowserBookmark home }
			 iconName: 'group') }.
	"you define the bookmarks have to be instance of FDAbstractBookMark"

	presenter columns: { StFileBrowserCreationDateColumn }.

	presenter inspect.
	presenter openModal.
	presenter resetBookmarks.
	^ presenter confirm
]

{ #category : 'examples' }
StOpenFilePresenter class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenFilePresenter class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StOpenFilePresenter class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'example' }
StOpenFilePresenter class >> examplePreviewer [

	self new
		previewer: StFileBrowserInspectPreviewer new;
		open
]

{ #category : 'hooks' }
StOpenFilePresenter >> initialTitle [
	^ 'Select File To Open'
]

{ #category : 'testing' }
StOpenFilePresenter >> isMultipleSelection [
	"Answer <true> if the receiver was set to enable multiple selections"
	
	^ self fileNavigationSystem isMultipleSelection 
]
