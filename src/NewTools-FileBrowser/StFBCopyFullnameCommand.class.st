Class {
	#name : 'StFBCopyFullnameCommand',
	#superclass : 'StFBSelectionCommand',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBCopyFullnameCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallCopy;
		shortcutKey: $f meta;		
		yourself
]

{ #category : 'executing' }
StFBCopyFullnameCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	Clipboard clipboardText: self selectedEntry fullName
]

{ #category : 'initialization' }
StFBCopyFullnameCommand >> initialize [

	super initialize.
	self
		name: 'Copy full path';
		description: 'Copy the selected file full path name'
]
