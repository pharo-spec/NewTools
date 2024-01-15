"
Provides a command to compress the selected entry in the File Browser tool.

"
Class {
	#name : 'StFBCompressCommand',
	#superclass : 'StFBSelectionCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFBCompressCommand >> asSpecCommand [

	^ super asSpecCommand
		iconName: #smallForward;
		shortcutKey: $z meta;		
		yourself
]

{ #category : 'executing' }
StFBCompressCommand >> compressorExtension [

	^ '.zip'
]

{ #category : 'executing' }
StFBCompressCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	| zip newZipName |
	
	(newZipName := self selectedEntry withoutExtension basename , self compressorExtension) asFileReference exists
		ifTrue: [ self error: 'Compressed file already exists' ].
	zip := ZipArchive new.
	zip addFile: self selectedEntry.
	zip writeToFile: self selectedEntry parent / newZipName.
	zip close.
	self updateFileSystemContents
]

{ #category : 'initialization' }
StFBCompressCommand >> initialize [

	super initialize.
	self
		name: 'Compress';
		description: 'Compresss the selected file'
]
