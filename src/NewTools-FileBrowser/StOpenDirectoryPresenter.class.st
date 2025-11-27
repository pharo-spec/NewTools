"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : 'StOpenDirectoryPresenter',
	#superclass : 'StOpenFileOrDirectoryPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'accessing' }
StOpenDirectoryPresenter class >> defaultPreferredExtent [ 

	^ (1050 @ 550)
]

{ #category : 'examples' }
StOpenDirectoryPresenter class >> example [

	<example>
	^ self chooseThenInspect
]

{ #category : 'examples' }
StOpenDirectoryPresenter class >> exampleModal [

	<example>
	^ self chooseModalAndInspect
]

{ #category : 'hooks' }
StOpenDirectoryPresenter class >> navigationSystemClass [
	
	^ StDirectoryNavigationSystemPresenter 
]

{ #category : 'accessing' }
StOpenDirectoryPresenter >> selectedEntry [

	super selectedEntry ifNotNil: [ :fileReference | 
		fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'You must select a directory'.
	^ nil
]

{ #category : 'hooks' }
StOpenDirectoryPresenter >> windowTitle [

	^ title ifNil: [ 'Select Directory To Open' ]
]
