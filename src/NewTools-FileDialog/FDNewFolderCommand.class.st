"
i'm manage ContextMenu to creat Directory
"
Class {
	#name : #FDNewFolderCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileDialog-Commands'
}

{ #category : #converting }
FDNewFolderCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #add;
		yourself
]

{ #category : #hooks }
FDNewFolderCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."
	self context createDirectory
]

{ #category : #initialization }
FDNewFolderCommand >> initialize [
	super initialize.
	self
		name: 'New folder';
		description: 'Create a new folder inside the selected one.'
]
