"
i'm manage ContextMenu to creat Directory
"
Class {
	#name : #FDCreateDirectoryCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-FileDialog-Menu'
}

{ #category : #hooks }
FDCreateDirectoryCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."
	self context createDirectory
]

{ #category : #initialization }
FDCreateDirectoryCommand >> initialize [
	super initialize.
	self
		basicName: 'Create a directory';
		basicDescription: 'create a directory '
]
