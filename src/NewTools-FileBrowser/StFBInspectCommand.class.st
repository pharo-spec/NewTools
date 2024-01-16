"
I'm a inspect command use to inspect the selectedFile
"
Class {
	#name : 'StFBInspectCommand',
	#superclass : 'StFBSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBInspectCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallInspectIt;
		shortcutKey: $i meta;		
		yourself
]

{ #category : 'executing' }
StFBInspectCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self selectedEntry inspect
]

{ #category : 'initialization' }
StFBInspectCommand >> initialize [
	super initialize.
	self
		name: 'Inspect file';
		description: 'Inspect the selected file'
]
