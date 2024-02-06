"
I'm a inspect command use to inspect the selectedFile
"
Class {
	#name : 'StFileBrowserInspectCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserInspectCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallInspectIt;
		shortcutKey: $i meta;		
		yourself
]

{ #category : 'executing' }
StFileBrowserInspectCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self selectedEntry inspect
]

{ #category : 'initialization' }
StFileBrowserInspectCommand >> initialize [
	super initialize.
	self
		name: 'Inspect';
		description: 'Inspect the selected file'
]
