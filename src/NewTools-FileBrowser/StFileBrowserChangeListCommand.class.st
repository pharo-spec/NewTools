"
Implements an action to file in the selected file (representing a Pharo source code) into the current system
"
Class {
	#name : 'StFileBrowserChangeListCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserChangeListCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #changeSorter;
		shortcutKey: $b meta;
		yourself
]

{ #category : 'testing' }
StFileBrowserChangeListCommand >> canBeExecuted [

	^ self selectedEntry isFile and: [ self selectedEntryBasename endsWith: '.st' ]
]

{ #category : 'executing' }
StFileBrowserChangeListCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self application tools changeList openOnStream: self selectedEntry asFileReference readStream
]

{ #category : 'as yet unclassified' }
StFileBrowserChangeListCommand >> initialize [

	super initialize.
	self
		name: 'Changes Browser';
		description: 'Open a Changes Browser on the selected entry'
]
