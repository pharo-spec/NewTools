"
Implements an action to file in the selected file (representing a Pharo source code) into the current system
"
Class {
	#name : 'StFileBrowserRemoveCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserRemoveCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #remove;
		shortcutKey: $r meta;		
		yourself
]

{ #category : 'private' }
StFileBrowserRemoveCommand >> confirmNotEmpty [

	^ self application newConfirm
		 title: 'Confirmation';
		 label: 'The selected directory has contents. Please confirm removal of ' , self selectedEntryBasename;
		 acceptLabel: 'Continue';
		 cancelLabel: 'Cancel';
		 openModal
]

{ #category : 'testing' }
StFileBrowserRemoveCommand >> contextShouldReparent [
	"Answer <true> if the receiver should move to the parent of the current directory, for example in directory tree when the selected directory is deleted"

	^ self context shouldReparent.
]

{ #category : 'executing' }
StFileBrowserRemoveCommand >> execute [

	| entryToDelete |
	(self application newConfirm
		 title: 'Confirmation';
		 label: 'Please confirm removal of ' , self selectedEntryBasename;
		 acceptLabel: 'Continue';
		 cancelLabel: 'Cancel';
		 openModal) ifFalse: [ ^ self ].

	entryToDelete := self selectedEntry.
	self contextShouldReparent
		ifTrue: [ self context openFolder: self currentDirectory parent ].
	[ entryToDelete ensureDelete ]
	on: DirectoryIsNotEmpty
	do: [ : ex | 
		self confirmNotEmpty 
			ifTrue: [ entryToDelete ensureDeleteAll ]
			ifFalse: [ ^ self inform: 'Remove directory cancelled' ] ].
	self context updateFileSystemPresenters
]

{ #category : 'initialization' }
StFileBrowserRemoveCommand >> initialize [

	super initialize.
	self
		name: 'Remove';
		description: 'Remove the selected entry'
]
