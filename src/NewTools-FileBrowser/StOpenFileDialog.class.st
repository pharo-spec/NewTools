"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : 'StOpenFileDialog',
	#superclass : 'StOpenFileOrDirectoryDialog',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'example' }
StOpenFileDialog class >> complexExample [

	<example>
	| presenter |
	presenter := self new.

	presenter previewer: StFileBrowserContentPreviewer new.
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
StOpenFileDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenFileDialog class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : 'examples' }
StOpenFileDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'example' }
StOpenFileDialog class >> examplePreviewer [

	self new
		previewer: StFileBrowserInspectPreviewer new;
		open
]

{ #category : 'accessing - ui' }
StOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]
