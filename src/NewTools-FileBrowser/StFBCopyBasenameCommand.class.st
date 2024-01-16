Class {
	#name : 'StFBCopyBasenameCommand',
	#superclass : 'StFBSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBCopyBasenameCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallCopy;
		shortcutKey: $c meta;		
		yourself
]

{ #category : 'executing' }
StFBCopyBasenameCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	Clipboard clipboardText: self selectedEntry basename
]

{ #category : 'initialization' }
StFBCopyBasenameCommand >> initialize [

	super initialize.
	self
		name: 'Copy name';
		description: 'Copy the selected file name'
]
