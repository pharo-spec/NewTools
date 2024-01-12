"
Implements an action to file in the selected file (representing a Pharo source code) into the current system
"
Class {
	#name : 'StFBRemoveCommand',
	#superclass : 'StFBSelectionCommand',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBRemoveCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #remove;
		shortcutKey: $r meta;		
		yourself
]

{ #category : 'executing' }
StFBRemoveCommand >> execute [

	(self application newConfirm
		 title: 'Confirmation';
		 label: 'Please confirm removal of ' , self selectedEntryBasename;
		 acceptLabel: 'Continue';
		 cancelLabel: 'Cancel';
		 openModal) ifFalse: [ ^ self ].

	self selectedEntry ensureDelete.
	self context updateTableContent
]

{ #category : 'as yet unclassified' }
StFBRemoveCommand >> initialize [

	super initialize.
	self
		name: 'Remove';
		description: 'Remove the selected entry'
]
