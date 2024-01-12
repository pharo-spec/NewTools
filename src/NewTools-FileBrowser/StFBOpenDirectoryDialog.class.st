"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : 'StFBOpenDirectoryDialog',
	#superclass : 'StFBOpenFileOrDirectoryDialog',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StFBOpenDirectoryDialog class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StFBOpenDirectoryDialog class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'hooks' }
StFBOpenDirectoryDialog >> allowsChooseDirectoryIfNoFilename [

	^ true
]

{ #category : 'accessing - ui' }
StFBOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : 'initialization' }
StFBOpenDirectoryDialog >> initialize [

	super initialize.

	filter ifNil: [ filter := StFBDirectoryFilter new ]
]

{ #category : 'actions' }
StFBOpenDirectoryDialog >> selectedEntry [

	super selectedEntry ifNotNil: [ :fileReference | 
		fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'You must select a directory'.
	^ nil
]
