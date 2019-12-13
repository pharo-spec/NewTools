Extension { #name : #GTMoldableDebugger }

{ #category : #'*DebuggerSelector' }
GTMoldableDebugger >> actOnBrowserClosing: ann [
	"Terminating debug sessions is now handled by DebugSessionStorage, to allow other debuggers to re-open the debug session debugged by a GTDebugger after the latter has been closed"
	"self session ifNotNil: [ :aSession | aSession terminate ]"
	self session ifNotNil: [ :aSession | aSession stopKeepingAlive: self ]
]

{ #category : #'*DebuggerSelector' }
GTMoldableDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	
	| debugger |
	debugger := (Smalltalk tools 
		debuggerDispatcherFor: aDebugSession interruptedContext
		matching: [:aDebugger | aDebugger availableAutomatically ]) 
			ifNil: [ 
				"Use the current debugger"
				self on: aDebugSession ]
			ifNotNil: [ :aDebugger | 
				"Use a custom extension"
				aDebugger on: (aDebugger spanNewSessionFrom: aDebugSession) ].
	
	aDebugSession keepAlive: debugger.
	aBool | aString isNil "In case the string is nil it means we should show the full debugger and not a notification"
		ifTrue: [ debugger openWithFullView ]
		ifFalse: [ debugger openWithNotification: aString]
]
