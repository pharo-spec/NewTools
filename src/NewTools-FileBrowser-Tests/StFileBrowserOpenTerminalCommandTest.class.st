"
A StFileBrowserOpenTerminalCommandTest is a test class for testing the behavior of StFileBrowserOpenTerminalCommand
"
Class {
	#name : 'StFileBrowserOpenTerminalCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FileBrowser-Tests-Commands',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Commands'
}

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> terminalShellCommandTest: aBlock [

	self terminalShellCommandTest: aBlock withPath: '/dev/null' asPath.
	self terminalShellCommandTest: aBlock withPath: '/dev/null' asFileReference
]

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> terminalShellCommandTest: aBlock withPath: aPath [

	| command |
	command := aBlock
		           value: (StFileBrowserOpenTerminalCommand forContext:
				            StFileSystemModel new)
		           value: aPath.
	self assert: (command includesSubstring: 'dev').
	self assert: (command includesSubstring: 'null').
	self deny: (command includesSubstring: 'Path ').
	self deny: (command includesSubstring: 'File @ ')
]

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> testOpenLinuxTerminalShellCommand [

	self terminalShellCommandTest: [ :command :path |
		command openLinuxTerminalShellCommand: path ]
]

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> testOpenMacTerminalShellCommand [

	self terminalShellCommandTest: [ :command :path |
		command openMacTerminalShellCommand: path ]
]

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> testOpenWindowsTerminalShellCommand [

	self terminalShellCommandTest: [ :command :path |
		command openWindowsTerminalCommand: path ]
]

{ #category : 'tests' }
StFileBrowserOpenTerminalCommandTest >> testTerminalShellCommand [
	"tests for a current platform"

	self terminalShellCommandTest: [ :command :path |
		command terminalShellCommand: path ]
]
