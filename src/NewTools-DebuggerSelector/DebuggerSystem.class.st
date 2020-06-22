Class {
	#name : #DebuggerSystem,
	#superclass : #Object,
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #'default values' }
DebuggerSystem class >> defaultUIManager [
	^ UIManager default
]

{ #category : #'as yet unclassified' }
DebuggerSystem class >> handleDebugRequest: aDebugRequest [
	self defaultUIManager handleDebugRequest: aDebugRequest
]

{ #category : #'as yet unclassified' }
DebuggerSystem class >> handleWarningDebugRequest: aWarningDebugRequest [
	self defaultUIManager handleWarningDebugRequest: aWarningDebugRequest
]

{ #category : #'as yet unclassified' }
DebuggerSystem class >> openDebuggerOnRequest: aDebugRequest [
	| debuggerOpeningStrategy |
	
	self performPreDebugActionsIn: aDebugRequest.
	self spawnNewUIProcessIfNecessary: aDebugRequest.
	debuggerOpeningStrategy := DebuggerSelector_ newDebuggerSelector.
	"Schedule the debugger opening in a deferred UI message to address redraw problems after opening a debugger e.g. from the testrunner."
	self defaultUIManager defer: [ debuggerOpeningStrategy openOn: aDebugRequest debugSession ].
	aDebugRequest process suspend
]

{ #category : #'as yet unclassified' }
DebuggerSystem class >> performPreDebugActionsIn: aDebugRequest [
	aDebugRequest preDebugActions do: [ :preDebugAction | preDebugAction value: aDebugRequest debugSession ]
]

{ #category : #'as yet unclassified' }
DebuggerSystem class >> spawnNewUIProcessIfNecessary: aDebugRequest [
	"If @aDebugRequest is about debugging the UI process, we must create a new UI process to take its place. Because the debugged process will be suspended at some point, and suspending the UI process means freezing the UI of the image"
	| defaultUIManager |
	defaultUIManager := self defaultUIManager.
	(aDebugRequest process == defaultUIManager uiProcess) ifTrue: [ DefaultExecutionEnvironment
				beActiveDuring: [ defaultUIManager spawnNewProcess ] ]
]
