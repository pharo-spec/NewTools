"
I am the model used by the StProcessBrowser
"
Class {
	#name : 'StProcessBrowserModel',
	#superclass : 'Object',
	#instVars : [
		'processList',
		'lastUpdate'
	],
	#category : 'NewTools-ProcessBrowser-Browsers',
	#package : 'NewTools-ProcessBrowser',
	#tag : 'Browsers'
}

{ #category : 'defaults' }
StProcessBrowserModel class >> defaultStackDepth [

	^ 20
]

{ #category : 'private - accessing' }
StProcessBrowserModel >> allNonTerminatedProcesses [

	^ Process allProcesses reject: [ :each | each isTerminated or: [ each isTerminating ] ]
]

{ #category : 'initialization' }
StProcessBrowserModel >> initialize [

	super initialize.
	lastUpdate := 0
]

{ #category : 'accessing' }
StProcessBrowserModel >> processList [

	self updateProcessList.
	^ processList
]

{ #category : 'accessing' }
StProcessBrowserModel >> stackListFor: aProcess [

	aProcess ifNil: [ ^ #() ].
	
	^ self 
		stackListFor: aProcess 
		depth: self class defaultStackDepth
]

{ #category : 'accessing' }
StProcessBrowserModel >> stackListFor: aProcess depth: depth [

	^ (aProcess == Processor activeProcess)
		ifTrue: [ thisContext stackOfSize: depth ]
		ifFalse: [ 
			aProcess suspendedContext
				ifNotNil: [ :aContext | aContext stackOfSize: depth ]
				ifNil: [ #() ] ]
]

{ #category : 'updating' }
StProcessBrowserModel >> updateProcessList [
	| now |

	now := Time millisecondClockValue.
	now - lastUpdate < 500 ifTrue: [^ self].
	
	"Don't update too fast"
	lastUpdate := now.
	"oldSelectedProcess := selectedProcess.
	processList := selectedProcess := selectedSelector := nil."
	Smalltalk garbageCollectMost.
	"lose defunct processes"
	processList := self allNonTerminatedProcesses.
	processList := processList sort: #priority descending.
	processList := WeakArray withAll: processList
]
