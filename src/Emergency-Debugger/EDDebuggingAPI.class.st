"
I am the default ED Debugging interface.
I return a set of CmCommands exposing my interface.
"
Class {
	#name : #EDDebuggingAPI,
	#superclass : #Object,
	#instVars : [
		'session',
		'debugger',
		'forbiddenProcesses'
	],
	#category : #'Emergency-Debugger'
}

{ #category : #start }
EDDebuggingAPI class >> attachTo: aDebugSession [
	^ self new
		session: aDebugSession;
		yourself
]

{ #category : #accessing }
EDDebuggingAPI class >> displayStackSize [
	^5
]

{ #category : #'API - Processes' }
EDDebuggingAPI >> allRunningProcesses [
	^ Process allSubInstances
		reject: [ :each | 
			each isTerminated
				or: [ self forbiddenProcesses anySatisfy: [ :block | block value == each ] ] ]
]

{ #category : #'API - Revert' }
EDDebuggingAPI >> changeRecordsForMethod: aRgMethodHistoricalRingDefinition [
	^ SourceFiles
		changeRecordsFrom: aRgMethodHistoricalRingDefinition sourcePointer
		className: aRgMethodHistoricalRingDefinition instanceSideParentName
		isMeta: aRgMethodHistoricalRingDefinition isMetaSide
]

{ #category : #'API - Debugging support' }
EDDebuggingAPI >> closeEmergencySession [
	debugger terminate.
	self currentWorld restoreMorphicDisplay
]

{ #category : #accessing }
EDDebuggingAPI >> debugger: anObject [
	debugger := anObject
]

{ #category : #'API - Processes' }
EDDebuggingAPI >> forbiddenProcesses [
	^ forbiddenProcesses
		ifNil: [ forbiddenProcesses := {[  ].
			[ Smalltalk lowSpaceWatcherProcess ].
			[ WeakArray runningFinalizationProcess ].
			[ Processor backgroundProcess ].
			[ InputEventFetcher default fetcherProcess ].
			[ UIManager default uiProcess ].
			[ Delay schedulingProcess ]} ]
]

{ #category : #'API - Stack' }
EDDebuggingAPI >> maxStackSize [
	^self class displayStackSize
]

{ #category : #'API - Context' }
EDDebuggingAPI >> nodeForContext: aContext [
	^ aContext method sourceNodeForPC: aContext pc
]

{ #category : #'API - Revert' }
EDDebuggingAPI >> revert: method to: aChangeRecord [
	"Reverts the given method to the given change record"

	method asRingDefinition realClass
		compile: aChangeRecord sourceCode
		classified: aChangeRecord category
		withStamp: aChangeRecord stamp
		notifying: nil
]

{ #category : #'API - Revert' }
EDDebuggingAPI >> rgMethodHistorical: aMethod [
	^ aMethod asHistoricalRingDefinition
]

{ #category : #accessing }
EDDebuggingAPI >> session: anObject [
	session := anObject
]

{ #category : #'API - Stack' }
EDDebuggingAPI >> stack [ 	
	^session stackOfSize: self maxStackSize
]

{ #category : #'API - Processes' }
EDDebuggingAPI >> terminateAllProcesses [
	self terminateSession.
	self allRunningProcesses
		do: [ :process | process ifNotNil: [ process terminate ] ]
]

{ #category : #'API - Debugging support' }
EDDebuggingAPI >> terminateSession [
	self closeEmergencySession.
	session terminate
]

{ #category : #'API - Debugging support' }
EDDebuggingAPI >> tryReopenSessionWithDebugger [
	self closeEmergencySession.
	UIManager default
		defer: [ [ Smalltalk tools debugger
				openOn: session
				withFullView: true
				andNotification: nil ]
				on: Error
				do: [ :ex | session signalDebuggerError: ex ] ]
]

{ #category : #'API - Revert' }
EDDebuggingAPI >> versionsForMethod: aMethod [
	^ (self changeRecordsForMethod: (self rgMethodHistorical: aMethod))
		collectWithIndex: [ :c :i | 
			| rg |
			rg := c asRingDefinition.
			rg annotationNamed: #versionIndex put: i ]
]
