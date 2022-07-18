"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : #StFBOpenFileDialog,
	#superclass : #StFBOpenFileOrDirectoryDialog,
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #example }
StFBOpenFileDialog class >> complexExample [

	<example>
	| presenter |
	presenter := self new.

	presenter previewer: StFBContentPreviewer new.
	"with this when you select a png file it will display it"

	presenter filter:
		{ (StFBCustomExtensionsFilter extensions: #( '.image' )) }.
	"you can add 1 own filter"

	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"

	presenter okAction: [ :selectedFileReference | selectedFileReference ].
	"you will define the action of the OK button "

	presenter bookmarks: { (StFBGroupBookmark
			 name: 'exampleGroup'
			 collection: { 
					 StFBBookmark image.
					 StFBBookmark home }
			 iconName: 'group') }.
	"you define the bookmarks have to be instance of FDAbstractBookMark"

	presenter columns: { StFBCreationDateColumn }.

	presenter inspect.
	presenter openModal.
	^ presenter confirm
]

{ #category : #examples }
StFBOpenFileDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : #examples }
StFBOpenFileDialog class >> exampleExtensions [

	<example>
	^ self extensions: #( 'image' )
]

{ #category : #examples }
StFBOpenFileDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : #example }
StFBOpenFileDialog class >> examplePreviewer [

	self new
		previewer: StFBInspectPreviewer new;
		open
]

{ #category : #'accessing - ui' }
StFBOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]
