"
I show or hide the hidden files and folders ('Toggle hidden files', file table menu) by switching `StFileBrowserSettings showHiddenFiles`, so the change is also seen in the settings.
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
