"
File utilities
"
Class {
	#name : #StSimpleFileUtils,
	#superclass : #Object,
	#classVars : [
		'IconCache'
	],
	#category : #'NewTools-SimpleFileBrowser-Core'
}

{ #category : #'private - testing' }
StSimpleFileUtils class >> isLinux [
	^Smalltalk os version beginsWith: 'linux'
]

{ #category : #'private - testing' }
StSimpleFileUtils class >> isMac [ 
	^Smalltalk os isMacOS
]

{ #category : #'private - testing' }
StSimpleFileUtils class >> isWindows [ 
	^Smalltalk os isWindows
]

{ #category : #'private - actions' }
StSimpleFileUtils class >> openLinuxTerminalOn: aPath [

	(Delay forMilliseconds: 1000) wait.  	
	(LibC system: 'gnome-terminal --working-directory=',aPath,' &')
	
 
]

{ #category : #'private - actions' }
StSimpleFileUtils class >> openMacTerminalOn: aPath [

	| escaped |
	escaped := aPath copyReplaceAll: ' ' with: '\ '. 	
	LibC system: 'open -a Terminal ', escaped
]

{ #category : #actions }
StSimpleFileUtils class >> openTerminalOn: aPath [

	self isWindows 
		ifTrue: [ ^self openWindowsTerminalOn: aPath ].
	self isMac
		ifTrue: [ ^self openMacTerminalOn: aPath ].
	self isLinux
		ifTrue: [ ^self openLinuxTerminalOn: aPath ].
	
	self inform: 'No terminal for platform implemented'		

]

{ #category : #'private - actions' }
StSimpleFileUtils class >> openWindowsTerminalOn: aPath [

	^LibC system: 'start cmd.exe /K "cd /d ', aPath, '"'
]

{ #category : #testing }
StSimpleFileUtils class >> representsShortWindowsDrive: aString [
	"Solve later with a regexp
	
 	  HRBFileUtils representsShortWindowsDrive: 'C:'
	"
	aString first isLetter ifFalse: [ ^false ].
	aString first isUppercase ifFalse: [ ^false ].
	aString size = 2 ifTrue: [ ^aString second = $: ].
	^false
]
