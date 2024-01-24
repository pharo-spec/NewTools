"
I specialize a debug session for Morphic backends used by spec tools
"
Class {
	#name : 'StMorphicDebugSession',
	#superclass : 'DebugSession',
	#instVars : [
		'application',
		'errorWasInUIProcess',
		'backend'
	],
	#category : 'NewTools-Debugger-Morphic',
	#package : 'NewTools-Debugger-Morphic'
}

{ #category : 'instance creation' }
StMorphicDebugSession class >> newFromSession: aDebugSession [

	^ (self
		   named: aDebugSession name
		   on: aDebugSession interruptedProcess
		   startedAt: aDebugSession interruptedContext)
		  exception: aDebugSession exception;
		  detectUIProcess;
		  yourself
]

{ #category : 'accessing' }
StMorphicDebugSession >> backend: aSpMorphicBackend [

	backend := aSpMorphicBackend
]

{ #category : 'debugging actions' }
StMorphicDebugSession >> deferDebuggerOpeningToBackend: aStDebugger [

	backend defer: [ aStDebugger openWithFullView ]
]

{ #category : 'process' }
StMorphicDebugSession >> detectUIProcess [

	errorWasInUIProcess := MorphicUIManager uiProcess
	                       == interruptedProcess.
	errorWasInUIProcess ifTrue: [ self spawnNewUIProcess ]
]

{ #category : 'accessing' }
StMorphicDebugSession >> errorWasInUIProcess [

	^ errorWasInUIProcess
]

{ #category : 'accessing' }
StMorphicDebugSession >> errorWasInUIProcess: aBoolean [

	errorWasInUIProcess := aBoolean
]

{ #category : 'private' }
StMorphicDebugSession >> resumeInterruptedProcess [

	errorWasInUIProcess ifFalse: [ ^ super resumeInterruptedProcess ].
	MorphicUIManager default resumeUIProcess: interruptedProcess
]

{ #category : 'process' }
StMorphicDebugSession >> spawnNewUIProcess [

	DefaultExecutionEnvironment beActiveDuring: [
		MorphicUIManager default spawnNewProcess ]
]

{ #category : 'process' }
StMorphicDebugSession >> spawnNewUIProcessIfNecessary [
	"If we're about to debug the UI process, we must create a new UI process to take its place. Because the debugged process will be suspended at some point, and suspending the UI process means freezing the UI of the image"

	errorWasInUIProcess ifTrue: [ self spawnNewUIProcess ]
]

{ #category : 'debugging actions' }
StMorphicDebugSession >> terminate [

	self interruptedProcess ifNotNil: [ ^ super terminate ].
	
	"Assume the interrupted process was resumed." 
	"Kill the active process if the error was in the UI as there should be only one UI process."
	self errorWasInUIProcess ifTrue: [ Processor terminateActive ]
]
