"
I'm a little tool that display information about the system.

```
StSystemReporter new open.
StSystemReporter open
```


"
Class {
	#name : 'StSystemReporterPresenter',
	#superclass : 'StReporterPresenter',
	#category : 'NewTools-SystemReporter-Base',
	#package : 'NewTools-SystemReporter',
	#tag : 'Base'
}

{ #category : 'system menu' }
StSystemReporterPresenter class >> systemReporterMenuOn: aBuilder [ 
	<worldMenu>
	
	(aBuilder item: #'System Reporter')
		parent: #SystemTools;
		action: [ self open ];
		order: 1;
		help: 'If you have a bug, use this tool to provide information about your system.'
]

{ #category : 'initialization' }
StSystemReporterPresenter >> connectPresenters [ 

	super connectPresenters.
	topicList  selectIndex: 1.
]

{ #category : 'utils' }
StSystemReporterPresenter >> extent [

	^ 500@ 600
]

{ #category : 'initialization' }
StSystemReporterPresenter >> fillTopics [ 
	
	 {
		(#Image -> #reportImage:) .
		(#'Image Parameters' -> #reportImageParameters:).
		(#'Image Sources' -> #reportSources:).
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

{ #category : 'utils' }
StSystemReporterPresenter >> isLinux [
	
	^Smalltalk os isLinux
]

{ #category : 'utils' }
StSystemReporterPresenter >> isWindows [

	^Smalltalk os isWindows
]

{ #category : 'building report' }
StSystemReporterPresenter >> readContentsSafelyFromFile: osPath andWriteTo: aStream [
	 [ osPath asFileReference readStreamDo: [:s | aStream nextPutAll: s contents ]
    ] on: Error do: [:ex| ex return: ex printString]
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportImage: aStream [
	self header: 'Image' on: aStream.
	aStream 
		nextPutAll: Smalltalk image imagePath; cr;
		nextPutAll: SystemVersion current version; cr;
		nextPutAll: Smalltalk image lastUpdateString; cr
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportImageParameters: aStream [
	self header: 'Image Commandline Parameters' on: aStream.
	self enumerate: [:idx | Smalltalk image argumentAt: idx] on: aStream
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportLinuxOSDetails: aStream [
	self header: 'Operating System Details' on: aStream.
	#(
		'/etc/issue'
		'/etc/lsb-release'
		'/proc/version'
	) do: [:path|
		self readContentsSafelyFromFile: path andWriteTo: aStream]
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportModules: aStream [

	self header: 'Loaded VM Modules' on: aStream.
	Smalltalk vm listLoadedModules asSortedCollection do: [:each | aStream nextPutAll: each; cr].
	aStream cr.
	self header: 'VM Built-in Modules' on: aStream.
	Smalltalk vm listBuiltinModules asSortedCollection do: [:each | aStream nextPutAll: each; cr]


]

{ #category : 'building report' }
StSystemReporterPresenter >> reportOS: aStream [
	self header: 'Operating System/Hardware' on: aStream.
	aStream
		nextPutAll: Smalltalk os platformName; space;
		nextPutAll: Smalltalk os version; space;
		nextPutAll: Smalltalk os subtype; cr

]

{ #category : 'building report' }
StSystemReporterPresenter >> reportOSEnvironment: aStream [
	| env |
	self header: 'Operating System Environment' on: aStream.
	env := [ Smalltalk os environment] on: Error do: [ ^self ].
	env keys asSortedCollection do: [:name |
		aStream nextPutAll: name; nextPut: $=; nextPutAll: (env at: name); cr ]
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportSources: aStream [
	self header: 'Image Sources' on: aStream.
	aStream nextPutAll: SourceFiles class printString; cr.
	aStream nextPutAll: SourceFiles reportString.
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportVM: aStream [
	self header: 'Virtual Machine' on: aStream.
	aStream
		nextPutAll: Smalltalk vm vmFileName;
		cr;
		nextPutAll: Smalltalk vm version;
		cr.
	Smalltalk vm buildDate
		ifNotNil: [ :string | 
			aStream
				nextPutAll: string;
				cr ].
	[ 
	Smalltalk vm platformSourceVersion
		ifNotNil: [ :v | 
			aStream
				nextPutAll: 'platform sources revision ';
				nextPutAll: v;
				cr ] ]
		on: Warning
		do: [ 
			"unsupported primitive"
			 ].
	[ 
	Smalltalk vm interpreterSourceVersion
		ifNotNil: [ :v | 
			aStream
				nextPutAll: 'VMMaker versionString ';
				nextPutAll: v;
				cr ] ]
		on: Warning
		do: [ 
			"unsupported primitive"
			 ].
	[ 
	Smalltalk vm interpreterClass
		ifNotNil: [ :string | 
			aStream
				nextPutAll: string;
				cr ].
	Smalltalk vm cogitClass
		ifNotNil: [ :string | 
			aStream
				nextPutAll: string;
				cr ] ]
		on: Error
		do: [ 
			"unsupported primitives"
			 ]
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportVMOptions: aStream [
	self header: 'Virtual Machine Commandline Options' on: aStream.
	self enumerate: [:idx | Smalltalk vm optionAt: idx] startAt: 1 on: aStream
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportVMParameters: aStream [
	| vmParameters |
	self header: 'Virtual Machine Parameters' on: aStream.
	vmParameters := Smalltalk vm getParameters.
	Smalltalk vm parameterLabels
			 pairsDo: [:idx :desc |
		aStream
			nextPut: $#;
			nextPutAll: idx printString;
			tab;
			nextPutAll: (vmParameters at: idx) printString;
			tab;
			nextPutAll: desc;
			cr]
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportVMStats: aStream [
	self header: 'Virtual Machine Statistics' on: aStream.
	aStream
		nextPutAll: Smalltalk vm statisticsReport
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportWin32GFXDetails: aStream [
	self header: 'Graphics Hardware Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10003)
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportWin32HardwareDetails: aStream [
	self header: 'Hardware Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10001)
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportWin32OSDetails: aStream [
	self header: 'Operating System Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10002)
]

{ #category : 'building report' }
StSystemReporterPresenter >> reportWin32VMConfig: aStream [
	| exePath iniPath |
	self header: 'VM Configuration' on: aStream.
	exePath := Smalltalk vm vmFileName.
	iniPath := (exePath copyUpToLast: $.), '.ini'.
	aStream nextPutAll: iniPath; cr; cr.
	self readContentsSafelyFromFile: iniPath andWriteTo: aStream

]

{ #category : 'utils' }
StSystemReporterPresenter >> title [ 
	^ 'System Reporter'
]

{ #category : 'initialization' }
StSystemReporterPresenter >> topicSpec [
	
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
