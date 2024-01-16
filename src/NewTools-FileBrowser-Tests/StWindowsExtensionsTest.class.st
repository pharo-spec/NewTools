"
A test specific to extensions for Windows OS platform
"
Class {
	#name : 'StWindowsExtensionsTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FileBrowser-Tests-OS-Specific',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'OS-Specific'
}

{ #category : 'tests' }
StWindowsExtensionsTest >> testWindowsAttributes [
	"Calling the native API should not give an error on windows"
	
	Smalltalk os isWindows ifFalse: [ ^self ].
	
	self assert: FileSystem workingDirectory windowsAttributes ~= -1
]

{ #category : 'tests' }
StWindowsExtensionsTest >> testWindowsAttributesForMemoryFileSystem [
	"Calling the native API should not give an error on windows"
	
	Smalltalk os isWindows ifFalse: [ ^self ].
	
	self assert: FileSystem memory root windowsAttributes equals: 22
]
