"
Implements an action to file in the selected file (representing a Pharo source code) into the current system
"
Class {
	#name : 'StFBChangeListCommand',
	#superclass : 'StFBSelectionCommand',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBChangeListCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #changeSorter;
		shortcutKey: $b meta;
		yourself
]

{ #category : 'testing' }
StFBChangeListCommand >> canBeExecuted [

	^ self selectedEntry isFile and: [ self selectedEntryBasename endsWith: '.st' ]
]

{ #category : 'executing' }
StFBChangeListCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self application tools changeList openOnStream: self selectedEntry asFileReference readStream
]

{ #category : 'as yet unclassified' }
StFBChangeListCommand >> initialize [

	super initialize.
	self
		name: 'Changes Browser';
		description: 'Open a Changes Browser on the selected entry'
]
