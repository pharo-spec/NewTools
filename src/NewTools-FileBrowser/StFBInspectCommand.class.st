"
I'm a inspect command use to inspect the selectedFile
"
Class {
	#name : #StFBInspectCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileBrowser-Commands'
}

{ #category : #converting }
StFBInspectCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #smallInspectIt;
		yourself
]

{ #category : #hooks }
StFBInspectCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self context selectedEntry inspect
]

{ #category : #initialization }
StFBInspectCommand >> initialize [
	super initialize.
	self
		name: 'Inspect file';
		description: 'Inspect the selected file'
]
