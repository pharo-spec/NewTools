Extension { #name : #GTMoldableDebugger }

{ #category : #'*NewTools-DebuggerSelector-Deprecated' }
GTMoldableDebugger >> actOnBrowserClosing: ann [
	self session ifNotNil: [ :aSession | aSession terminate ]
]

{ #category : #'*NewTools-DebuggerSelector-Deprecated' }
GTMoldableDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	
	| debugger |	
	"debugger := (Smalltalk tools 
		debuggerDispatcherFor: aDebugSession interruptedContext
		matching: [:aDebugger | aDebugger availableAutomatically ]) 
			ifNil: [ 
				""Use the current debugger""
				self on: aDebugSession ]
			ifNotNil: [ :aDebugger | 
				""Use a custom extension""
				aDebugger on: (aDebugger spanNewSessionFrom: aDebugSession) ]."
	
	debugger := self on: aDebugSession "(self spanNewSessionFrom: aDebugSession)".
	debugger originalSession: aDebugSession.
	
	aDebugSession keepAlive: debugger.
	aBool | aString isNil "In case the string is nil it means we should show the full debugger and not a notification"
		ifTrue: [ debugger openWithFullView ]
		ifFalse: [ debugger openWithNotification: aString].
	^ debugger
]
