"
i'm manage ContextMenu to creat Directory
"
Class {
	#name : 'StFBNewFolderCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBNewFolderCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : 'hooks' }
StFBNewFolderCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."
	self context createDirectory
]

{ #category : 'initialization' }
StFBNewFolderCommand >> initialize [
	super initialize.
	self
		name: 'New folder';
		description: 'Create a new folder inside the selected one.'
]
