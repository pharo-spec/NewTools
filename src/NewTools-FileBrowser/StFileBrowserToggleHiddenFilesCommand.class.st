"
I am a command to be able to toggle the display of hidden files and folders in a file browser directly from a menu and not from the settings only.
"
Class {
	#name : 'StFileBrowserToggleHiddenFilesCommand',
	#superclass : 'StFileBrowserCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserToggleHiddenFilesCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #lock;
		yourself
]

{ #category : 'executing' }
StFileBrowserToggleHiddenFilesCommand >> execute [

	StFileBrowserSettings showHiddenFiles: StFileBrowserSettings showHiddenFiles not.
	self context updateFileSystemPresenters
]

{ #category : 'initialization' }
StFileBrowserToggleHiddenFilesCommand >> initialize [
	super initialize.
	self
		name: 'Toggle hidden files';
		description: 'Toggle the display of hidden files and folders'
]
