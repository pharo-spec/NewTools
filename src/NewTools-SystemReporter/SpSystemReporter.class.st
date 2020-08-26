"
I'm a little tool that display information about the system.

```
SpSystemReporter new openWithSpec.
SpSystemReporter open
```


"
Class {
	#name : #SpSystemReporter,
	#superclass : #SpReporter,
	#category : #'NewTools-SystemReporter'
}

{ #category : #'system menu' }
SpSystemReporter class >> systemReporterMenuOn: aBuilder [ 
	<worldMenu>
	
	(aBuilder item: #'System Reporter')
		parent: #System;
		action: [ self open ];
		help: 'If you have a bug, use this tool to provide information about your system.'
]

{ #category : #initialization }
SpSystemReporter >> connectPresenters [ 

	super connectPresenters.
	topicList  selectIndex: 1.
]

{ #category : #utils }
SpSystemReporter >> extent [

	^ 500@ 600
]

{ #category : #utils }
SpSystemReporter >> isLinux [
	
	^Smalltalk os isLinux
]

{ #category : #utils }
SpSystemReporter >> isWindows [

	^Smalltalk os isWindows
]

{ #category : #'building report' }
SpSystemReporter >> readContentsSafelyFromFile: osPath andWriteTo: aStream [
	 [ osPath asFileReference readStreamDo: [:s | aStream nextPutAll: s contents ]
    ] on: Error do: [:ex| ex return: ex printString]
]

{ #category : #'building report' }
SpSystemReporter >> reportImage: aStream [
	self header: 'Image' on: aStream.
	aStream 
		nextPutAll: Smalltalk image imagePath; cr;
		nextPutAll: SystemVersion current version; cr;
		nextPutAll: Smalltalk image lastUpdateString; cr;
		nextPutAll: ChangeSet current name; cr

]

{ #category : #'building report' }
SpSystemReporter >> reportImageParameters: aStream [
	self header: 'Image Commandline Parameters' on: aStream.
	self enumerate: [:idx | Smalltalk image argumentAt: idx] on: aStream
]

{ #category : #'building report' }
SpSystemReporter >> reportLinuxOSDetails: aStream [
	self header: 'Operating System Details' on: aStream.
	#(
		'/etc/issue'
		'/etc/lsb-release'
		'/proc/version'
	) do: [:path|
		self readContentsSafelyFromFile: path andWriteTo: aStream]
]

{ #category : #'building report' }
SpSystemReporter >> reportModules: aStream [

	self header: 'Loaded VM Modules' on: aStream.
	Smalltalk vm listLoadedModules asSortedCollection do: [:each | aStream nextPutAll: each; cr].
	aStream cr.
	self header: 'VM Built-in Modules' on: aStream.
	Smalltalk vm listBuiltinModules asSortedCollection do: [:each | aStream nextPutAll: each; cr]


]

{ #category : #'building report' }
SpSystemReporter >> reportOS: aStream [
	self header: 'Operating System/Hardware' on: aStream.
	aStream
		nextPutAll: Smalltalk os platformName; space;
		nextPutAll: Smalltalk os version; space;
		nextPutAll: Smalltalk os subtype; cr

]

{ #category : #'building report' }
SpSystemReporter >> reportOSEnvironment: aStream [
	| env |
	self header: 'Operating System Environment' on: aStream.
	env := [ Smalltalk os environment] on: Error do: [ ^self ].
	env keys asSortedCollection do: [:name |
		aStream nextPutAll: name; nextPut: $=; nextPutAll: (env at: name); cr ]
]

{ #category : #'building report' }
SpSystemReporter >> reportRepositories: aStream [
	self header: 'Monticello Repositories' on: aStream.
	MCRepositoryGroup default repositories do: [:each | aStream nextPutAll: each description; cr]
]

{ #category : #'building report' }
SpSystemReporter >> reportSources: aStream [
	self header: 'Image Sources' on: aStream.
	aStream nextPutAll: SourceFiles class printString; cr.
	aStream nextPutAll: SourceFiles reportString.
]

{ #category : #'building report' }
SpSystemReporter >> reportVM: aStream [
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

{ #category : #'building report' }
SpSystemReporter >> reportVMOptions: aStream [
	self header: 'Virtual Machine Commandline Options' on: aStream.
	self enumerate: [:idx | Smalltalk vm optionAt: idx] startAt: 1 on: aStream
]

{ #category : #'building report' }
SpSystemReporter >> reportVMParameters: aStream [
	| vmParameters |
	self header: 'Virtual Machine Parameters' on: aStream.
	vmParameters := Smalltalk vm getParameters.
	#(
		1 'end (v3)/size(Spur) of old-space (0-based, read-only)'
		2 'end (v3)/size(Spur) of young/new-space (read-only)'
		3 'end (v3)/size(Spur) of heap (read-only)'
		4 'nil (was allocationCount (read-only))'
		5 'nil (was allocations between GCs (read-write)'
		6 'survivor count tenuring threshold (read-write)'
		7 'full GCs since startup (read-only)'
		8 'total milliseconds in full GCs since startup (read-only)'
		9 'incremental GCs (SqueakV3) or scavenges (Spur) since startup (read-only)'
		10 'total milliseconds in incremental GCs (SqueakV3) or scavenges (Spur) since startup (read-only)'
		11 'tenures of surving objects since startup (read-only)'
		12 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		13 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		14 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		15 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		16 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		17 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		18 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		19 '12-20 were specific to ikp''s JITTER VM, now 12-19 are open for use'
		20	'utc microseconds at VM start-up (actually at time initialization, which precedes image load).'
		21	'root table size (read-only)'
		22	'root table overflows since startup (read-only)'
		23	'bytes of extra memory to reserve for VM buffers, plugins, etc (stored in image file header).'
		24	'memory threshold above which shrinking object memory (rw)'
		25	'memory headroom when growing object memory (rw)'
		26	'interruptChecksEveryNms - force an ioProcessEvents every N milliseconds	(rw) 27	number of times mark loop iterated for current IGC/FGC (read-only)	includes ALL marking'
		28	'number of times sweep loop iterated for current IGC/FGC (read-only)'
		29	'number of times make forward loop iterated for current IGC/FGC	(read-only) 30	number of times compact move loop iterated for current	IGC/FGC (read-only)'
		31	'number of grow memory requests (read-only)'
		32	'number of shrink memory requests (read-only)'
		33	'number of root table entries used for current IGC/FGC (read-only)'
		34	'number of allocations done before current IGC/FGC (read-only)'
		35	'number of survivor objects after current IGC/FGC (read-only)'
		36	'millisecond clock when current IGC/FGC completed (read-only)'
		37	'number of marked objects for Roots of the world, not including Root	Table entries for current IGC/FGC (read-only)'
		38	'milliseconds taken by current IGC (read-only)'
		39	'Number of finalization signals for Weak Objects pending when current	IGC/FGC completed (read-only)'
		40	'BytesPerOop for this image'
		41	'imageFormatVersion for the VM'
		42	'number of stack pages in use'
		43	'desired number of stack pages (stored in image file header, max 65535)'
		44	'size of eden, in bytes'
		45	'desired size of eden, in bytes (stored in image file header)'
		46	'machine code zone size, in bytes (Cog only; otherwise nil)'
		47	'desired machine code zone size (stored in image file header; Cog only;	otherwise nil)'
		48	'various header flags. See getCogVMFlags.'
		49	'max size the image promises to grow the external semaphore table to (0	sets to default, which is 256 as of writing)'
		50	'nil; reserved for VM parameters that persist in the image (such as	eden above)'
		51 	'nil; reserved for VM parameters that persist in the image (such as	eden above)'
		52	'root table capacity'
		53	'number of segments (Spur only; otherwise nil)'
		54	'total size of free old space (Spur only, otherwise nil)'
		55	'ratio of growth and image size at or above which a GC will be performed	post scavenge'
		56	'number of process switches since startup (read-only)'
		57	'number of ioProcessEvents calls since startup (read-only)'
		58	'number of ForceInterruptCheck calls since startup (read-only)'
		59	'number of check event calls since startup (read-only)'
		60	'number of stack page overflows since startup (read-only)'
		61	'number of stack page divorces since startup (read-only)	62	compiled code compactions since startup (read-only; Cog only; otherwise nil)'
		63	'total milliseconds in compiled code compactions since startup	(read-only; Cog only; otherwise nil)'
		64	'the number of methods that currently have jitted machine-code'
		65	'whether the VM supports a certain feature, MULTIPLE_BYTECODE_SETS is bit 0, IMMTABILITY is bit 1'
		66	'the byte size of a stack page'
		67	'the max allowed size of old space (Spur only; nil otherwise; 0 implies	no limit except that of the underlying platform)'
		68	'the average number of live stack pages when scanned by GC (at	scavenge/gc/become et al)'
		69	'the maximum number of live stack pages when scanned by GC (at	scavenge/gc/become et al)'
		70	'the vmProxyMajorVersion (the interpreterProxy VM_MAJOR_VERSION)'
		71	'the vmProxyMinorVersion (the interpreterProxy VM_MINOR_VERSION)')
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

{ #category : #'building report' }
SpSystemReporter >> reportVMStats: aStream [
	self header: 'Virtual Machine Statistics' on: aStream.
	aStream
		nextPutAll: Smalltalk vm statisticsReport
]

{ #category : #'building report' }
SpSystemReporter >> reportWin32GFXDetails: aStream [
	self header: 'Graphics Hardware Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10003)
]

{ #category : #'building report' }
SpSystemReporter >> reportWin32HardwareDetails: aStream [
	self header: 'Hardware Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10001)
]

{ #category : #'building report' }
SpSystemReporter >> reportWin32OSDetails: aStream [
	self header: 'Operating System Details' on: aStream.
	aStream nextPutAll: (Smalltalk vm getSystemAttribute: 10002)
]

{ #category : #'building report' }
SpSystemReporter >> reportWin32VMConfig: aStream [
	| exePath iniPath |
	self header: 'VM Configuration' on: aStream.
	exePath := Smalltalk vm vmFileName.
	iniPath := (exePath copyUpToLast: $.), '.ini'.
	aStream nextPutAll: iniPath; cr; cr.
	self readContentsSafelyFromFile: iniPath andWriteTo: aStream

]

{ #category : #'building report' }
SpSystemReporter >> reportWorkingCopies: aStream [
	| list |
	self header: 'Monticello Working Copies' on: aStream.
	list := MCWorkingCopy allManagers asSortedCollection: [:a :b | a packageName <= b packageName].
	list do: [:each | aStream nextPutAll: each description; cr ]
]

{ #category : #utils }
SpSystemReporter >> title [ 
	^ 'System Reporter'
]

{ #category : #initialization }
SpSystemReporter >> topicSpec [
	
	| topics |
	topics := OrderedCollection new.
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
