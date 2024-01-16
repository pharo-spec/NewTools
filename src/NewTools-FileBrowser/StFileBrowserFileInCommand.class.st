"
Implements an action to file in the selected file (representing a Pharo source code) into the current system
"
Class {
	#name : 'StFileBrowserFileInCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserFileInCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #up;
		shortcutKey: $f meta;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : 'testing' }
StFileBrowserFileInCommand >> canBeExecuted [

	^ self selectedEntry isFile and: [ self selectedEntryBasename endsWith: '.st' ]
]

{ #category : 'executing' }
StFileBrowserFileInCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self selectedEntry fileIn
]

{ #category : 'initialization' }
StFileBrowserFileInCommand >> initialize [

	super initialize.
	self
		name: 'File in';
		description: 'File in the selected source file'
]
