"
I'm a little tool that display information about the system.

```
StSystemReporter new openWithSpec.
StSystemReporter open
```


"
Class {
	#name : #StSystemReporter,
	#superclass : #StReporter,
	#category : #'NewTools-SystemReporter'
}

{ #category : #'system menu' }
StSystemReporter class >> systemReporterMenuOn: aBuilder [ 
	<worldMenu>
	
	(aBuilder item: #'System Reporter')
		parent: #System;
		action: [ self open ];
		help: 'If you have a bug, use this tool to provide information about your system.'
]

{ #category : #initialization }
StSystemReporter >> connectPresenters [ 

	super connectPresenters.
	topicList  selectIndex: 1.
]

{ #category : #utils }
StSystemReporter >> extent [

	^ 500@ 600
]

{ #category : #initialization }
StSystemReporter >> fillTopics [ 
	
	 {
		(#Image -> #reportImage:) .
		(#'Image Parameters' -> #reportImageParameters:).
		(#'Image Sources' -> #reportSources:).
		(#'MC Repositories' -> #reportRepositories:).
		(#'MC Working Copies' -> #reportWorkingCopies:).
		(#'VM General' -> #reportVM:).
		(#'VM Options' -> #reportVMOptions:).
		(#'VM Modules' -> #reportModules:).
		(#'VM Parameters' -> #reportVMParameters:).
		(#'VM Stats' -> #reportVMStats:).
		(#OS -> #reportOS:).
		(#'OS Environment' -> #reportOSEnvironment:).
		} do: [ :each | self addTopicSpec: each ].
		
	self isWindows
		ifTrue: [ 
			{ (#'OS Details' -> #reportWin32OSDetails:).
			(#'VM Configuration' -> #reportWin32VMConfig:).
			(#'Hardware Details' -> #reportWin32HardwareDetails:).
			(#'GFX Hardware Details' -> #reportWin32GFXDetails:).	
			} do: [ :each | self addTopicSpec: each ]. 
			].	
		
	self isLinux 
		ifTrue: [ self addTopicSpec: #'OS Details' -> #reportLinuxOSDetails: ].
	^ topics
]

{ #category : #utils }
StSystemReporter >> isLinux [
	
	^Smalltalk os isLinux
]

{ #category : #utils }
StSystemReporter >> isWindows [

	^Smalltalk os isWindows
]

{ #category : #utils }
StSystemReporter >> title [ 
	^ 'System Reporter'
]

{ #category : #initialization }
StSystemReporter >> topicSpec [
	
	topics addAll:  {
		(#Image -> #reportImage:) .
		(#'Image Parameters' -> #reportImageParameters:).
		(#'Image Sources' -> #reportSources:).
		(#'MC Repositories' -> #reportRepositories:).
		(#'MC Working Copies' -> #reportWorkingCopies:).
		(#'VM General' -> #reportVM:).
		(#'VM Options' -> #reportVMOptions:).
		(#'VM Modules' -> #reportModules:).
		(#'VM Parameters' -> #reportVMParameters:).
		(#'VM Stats' -> #reportVMStats:).
		(#OS -> #reportOS:).
		(#'OS Environment' -> #reportOSEnvironment:).
		}.
		
	self isWindows
		ifTrue: [ topics addAll: {
			(#'OS Details' -> #reportWin32OSDetails:).
			(#'VM Configuration' -> #reportWin32VMConfig:).
			(#'Hardware Details' -> #reportWin32HardwareDetails:).
			(#'GFX Hardware Details' -> #reportWin32GFXDetails:).	
			} ].	
		
	self isLinux 
		ifTrue: [ topics add: #'OS Details' -> #reportLinuxOSDetails: ].
	^ topics
]
