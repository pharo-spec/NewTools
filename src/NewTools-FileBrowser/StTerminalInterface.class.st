"
I open a terminal of the operating system on a folder, for the 'Open terminal here' command.

## Life cycle: who creates me and who uses me

1. `StTerminalInterface default` lazily creates the shared instance; `default:` replaces it.
2. `StFileBrowserOpenTerminalCommand>>execute` asks it to `openTerminalOn:` the current folder.
3. I build the shell command for the current platform (`terminalShellCommand:`) and run it with `LibC system:`.

## Responsibility:

- Build the command opening a terminal on a folder: `open -a Terminal` on macOS (the program comes from `StFileBrowserSettings macTerminalProgram`), `gnome-terminal` on Linux, `cmd.exe` on Windows.
- Run it.

## Collaborators:

- `StFileBrowserOpenTerminalCommand`: my user.
- `StFileBrowserSettings`: the macOS terminal program.
- `LibC`: runs the command.

## Public API and Key Messages

- `StTerminalInterface default`, `StTerminalInterface default: anInterface`.
- `openTerminalOn: aFileReference`, `terminalShellCommand: aFileReference`.

## Examples

```smalltalk
StTerminalInterface exampleDefault.
```

`StFileBrowserOpenTerminalCommandTest` checks the command of each platform.

## Internal Representation

- `Default`: class variable, the shared instance.
"
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

{ #category : 'examples' }
StTerminalInterface class >> exampleDefault [

	<sampleInstance>
	^ self new
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
	OSPlatform current isLinux ifTrue: [ ^ self openLinuxTerminalShellCommand: aPath ].

	self inform: 'No terminal for platform implemented'.
	^ String empty
]
