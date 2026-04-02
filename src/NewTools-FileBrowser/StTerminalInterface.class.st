Class {
	#name : 'StTerminalInterface',
	#superclass : 'Object',
	#classVars : [
		'Default'
	],
	#category : 'NewTools-FileBrowser-Utilities',
	#package : 'NewTools-FileBrowser',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
StTerminalInterface class >> default [

	^ Default 
		ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
StTerminalInterface class >> default: aClass [ 
	
	Default := aClass
]

{ #category : 'accessing' }
StTerminalInterface >> openLinuxTerminalShellCommand: aPath [

	^ String streamContents: [ : stream |
		stream
			<< 'gnome-terminal --working-directory=';
			<< aPath fullName;
			<< ' &' ]
]

{ #category : 'accessing' }
StTerminalInterface >> openMacTerminalShellCommand: aPath [

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
StTerminalInterface >> openTerminalOn: aPath [

	(self terminalShellCommand: aPath)
		ifNotEmpty: [ : shellCmd | 
			(Delay forMilliseconds: 1000) wait.
			LibC system: shellCmd ]
]

{ #category : 'accessing' }
StTerminalInterface >> openWindowsTerminalCommand: aPath [

	^ String streamContents: [ : stream |
		stream
			<< 'start cmd.exe /K "cd /d ';
			<< aPath fullName;
			<< '"' ]
]

{ #category : 'accessing' }
StTerminalInterface >> preferredMacTerminalProgram [

	^ StFileBrowserSettings macTerminalProgram

]

{ #category : 'accessing' }
StTerminalInterface >> terminalShellCommand: aPath [
	"Answer a <String> with the shell command to open a terminal for the receiver's OS"

	OSPlatform current isWindows ifTrue: [ ^ self openWindowsTerminalCommand: aPath ].
	OSPlatform current isMacOS ifTrue: [ ^ self openMacTerminalShellCommand: aPath ].
	(Smalltalk os version beginsWith: 'linux') ifTrue: [ ^ self openLinuxTerminalShellCommand: aPath ].

	self inform: 'No terminal for platform implemented'.
	^ String empty
]
