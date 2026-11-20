"
I rename the selected entry with the name the user enters, and ask what to do when an entry with that name exists ('Rename', Meta+M, file table and directory tree menus).
"
Class {
	#name : 'StFileBrowserRenameCommand',
	#superclass : 'StFileBrowserSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserRenameCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallUpdate;
		shortcutKey: $m meta;		
		yourself
]

{ #category : 'private' }
StFileBrowserRenameCommand >> confirmRename: newName [

	| choice  chooseList |

	chooseList := {
		'Overwrite that file' .
		'Choose another name' .
		'Cancel' }.
	choice := self application newSelect
		items: chooseList;
		title: 'Rename';
		openModal.

	choice = chooseList first 
		ifTrue: [ ^ newName ].
	choice = chooseList second
		ifTrue: [ ^ self requestNewName ].
	^ nil
]

{ #category : 'executing' }
StFileBrowserRenameCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self requestNewName
		ifNotNil: [ : newName | 
			self selectedEntry renameTo: newName.
			self updateFileSystemPresenters ]
]

{ #category : 'initialization' }
StFileBrowserRenameCommand >> initialize [

	super initialize.
	self
		name: 'Rename';
		description: 'Rename the selected entry'
]

{ #category : 'initialization' }
StFileBrowserRenameCommand >> requestNewName [

	| newName reference |

	newName := self application newRequest 
		title: 'Rename';
		label: 'Enter a new file name';
		text: self selectedEntryBasename;
		openModal.

	(newName isNil or: [ newName trimBoth isEmpty ])
		ifTrue: [ self inform: 'Invalid new name'. ^ nil ].

	(reference := self selectedEntry parent / newName) exists 
		ifTrue:[ ^ self confirmRename: newName ].

	^ newName trimBoth
]
