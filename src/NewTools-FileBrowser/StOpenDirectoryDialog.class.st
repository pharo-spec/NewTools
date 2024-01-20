"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : 'StOpenDirectoryDialog',
	#superclass : 'StOpenFileOrDirectoryDialog',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StOpenDirectoryDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenDirectoryDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'hooks' }
StOpenDirectoryDialog >> allowsChooseDirectoryIfNoFilename [

	^ true
]

{ #category : 'hooks' }
StOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : 'hooks' }
StOpenDirectoryDialog >> navigationSystemClass [
	
	^ StDirectoryNavigationSystemPresenter 
]

{ #category : 'actions' }
StOpenDirectoryDialog >> selectedEntry [

	super selectedEntry ifNotNil: [ :fileReference | 
		fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'You must select a directory'.
	^ nil
]
