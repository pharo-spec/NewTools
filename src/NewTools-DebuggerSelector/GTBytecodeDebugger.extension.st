Extension { #name : 'GTBytecodeDebugger' }

{ #category : '*NewTools-DebuggerSelector' }
GTBytecodeDebugger classSide >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	<iAmADebugger>
	
]

{ #category : '*NewTools-DebuggerSelector' }
GTBytecodeDebugger classSide >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	^ super
		  openOn: (self spanNewSessionFrom: aDebugSession)
		  withFullView: aBool
		  andNotification: aString
]

{ #category : '*NewTools-DebuggerSelector' }
GTBytecodeDebugger classSide >> rank [
	^ 50
]

{ #category : '*NewTools-DebuggerSelector' }
GTBytecodeDebugger classSide >> rankDebugSession: aDebugSession [
	"Returns an integer representing how much this debugger is suitable to debug @aDebugSession. The higher the integer returned, the more suitable this debugger is. Signal the DebugSessionCannotBeOpenedByThisDebugger exception if this debugger absolutely cannot debug @aDebugSession (for example if this debugger can only handle debug sessions from test executions, and @aDebugSession does not come from a test execution)"
	(self handlesContext: aDebugSession interruptedContext) ifTrue: [ ^ self rank ] ifFalse: [ DebugSessionCannotBeOpenedByThisDebugger signal ]
]
