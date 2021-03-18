"
i'm manage ContextMenu to display/NotDisplay hidenFile 

"
Class {
	#name : #StFBToggleHiddenFilesCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileBrowser-Commands'
}

{ #category : #converting }
StFBToggleHiddenFilesCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #lock;
		yourself
]

{ #category : #hooks }
StFBToggleHiddenFilesCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."
	self context toggleHiddenFiles
]

{ #category : #hooks }
StFBToggleHiddenFilesCommand >> initialize [
	super initialize.
	self
		name: 'Toggle hidden files';
		description: 'appear/unappear hidden files'
]
