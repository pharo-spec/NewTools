"
Implements copy to clipboard the full path of the selected item in the File Browser.
"
Class {
	#name : 'StFileBrowserCopyFullnameCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserCopyFullnameCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallCopy;
		shortcutKey: $f meta;		
		yourself
]

{ #category : 'executing' }
StFileBrowserCopyFullnameCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	Clipboard clipboardText: self selectedEntry fullName
]

{ #category : 'initialization' }
StFileBrowserCopyFullnameCommand >> initialize [

	super initialize.
	self
		name: 'Copy full path';
		description: 'Copy the selected file full path name'
]
