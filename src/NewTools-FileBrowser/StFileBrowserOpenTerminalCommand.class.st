"
Implements a command to open a terminal in the host Operating System, from the File Browser.
"
Class {
	#name : 'StFileBrowserOpenTerminalCommand',
	#superclass : 'StFileBrowserCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'converting' }
StFileBrowserOpenTerminalCommand >> asSpecCommand [

	^ super asSpecCommand
		iconProvider: self iconProvider;
		iconName: #terminalIcon;
		shortcutKey: $n meta;		
		yourself
]

{ #category : 'executing' }
StFileBrowserOpenTerminalCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self openTerminalOn: self context currentDirectory
]

{ #category : 'initialization' }
StFileBrowserOpenTerminalCommand >> initialize [
	super initialize.
	self
		name: 'Open terminal here';
		description: 'Open an OS terminal in this directory.'
]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> openLinuxTerminalShellCommand: aPath [

	^ String streamContents: [ : stream |
		stream
			<< 'gnome-terminal --working-directory=';
			<< aPath fullName;
			<< ' &' ]
]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> openMacTerminalShellCommand: aPath [

	| escaped |
	escaped := aPath fullName copyReplaceAll: ' ' with: '\ '. 
	^ String streamContents: [ : stream |
		stream
			<< 'open -a ';
			<< self preferredMacTerminalProgram;
			space;
			<< escaped;
			<< ' &' ]
]

{ #category : 'accessing' }
StFileBrowserOpenTerminalCommand >> openTerminalOn: aPath [

	(self terminalShellCommand: aPath)
		ifNotEmpty: [ : shellCmd | 
			(Delay forMilliseconds: 1000) wait.
			LibC system: shellCmd ]

]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> openWindowsTerminalCommand: aPath [

	^ String streamContents: [ : stream |
		stream
			<< 'start cmd.exe /K "cd /d ';
			<< aPath fullName;
			<< '"' ]
]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> preferredLinuxTerminalProgram [

	^ StFileBrowserSettings linuxTerminalProgram

]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> preferredMacTerminalProgram [

	^ StFileBrowserSettings macTerminalProgram

]

{ #category : 'private' }
StFileBrowserOpenTerminalCommand >> preferredWindowsTerminalProgram [

	^ StFileBrowserSettings windowsTerminalProgram

]

{ #category : 'accessing' }
StFileBrowserOpenTerminalCommand >> terminalShellCommand: aPath [
	"Answer a <String> with the shell command to open a terminal for the receiver's OS"

	Smalltalk os isWindows
		ifTrue: [ ^ self openWindowsTerminalCommand: aPath ].
	Smalltalk os isMacOS
		ifTrue: [ ^ self openMacTerminalShellCommand: aPath ].
	(Smalltalk os version beginsWith: 'linux')
		ifTrue: [ ^ self openLinuxTerminalShellCommand: aPath ].
	
	self inform: 'No terminal for platform implemented'.
	^ String empty.
]
