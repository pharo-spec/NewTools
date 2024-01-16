Class {
	#name : 'StFileBrowserCopyBasenameCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserCopyBasenameCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallCopy;
		shortcutKey: $c meta;		
		yourself
]

{ #category : 'executing' }
StFileBrowserCopyBasenameCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	Clipboard clipboardText: self selectedEntry basename
]

{ #category : 'initialization' }
StFileBrowserCopyBasenameCommand >> initialize [

	super initialize.
	self
		name: 'Copy name';
		description: 'Copy the selected file name'
]
